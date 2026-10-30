import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/data/backup_service.dart';
import 'package:richfarmaci/data/db/app_database.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/medication.dart';
import 'package:richfarmaci/data/models/profile.dart';
import 'package:richfarmaci/data/repositories/medication_repository.dart';
import 'package:richfarmaci/data/repositories/profile_repository.dart';
import 'package:richfarmaci/data/repositories/sent_request_repository.dart';
import 'package:richfarmaci/data/settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixtures.dart';

void main() {
  late AppDatabase db;
  late SettingsStore settings;
  late BackupService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
    settings = await SettingsStore.open();
    service = BackupService(db: db, settings: settings);
  });

  tearDown(() => db.close());

  test('ripristina un backup dell\'app Kotlin (versione 1)', () async {
    final result = await service.restoreFromJson(kotlinBackup);

    expect(result.profiles, 1);
    expect(result.medications, 1);
    expect(result.sentRequests, 1);
    expect(result.skipped, 0);

    final p = (await ProfileRepository(db).getAll()).single;
    expect(p.pazienteNome, 'Mario Rossi');
    expect(p.tipoInvio, SendChannel.email);

    final r = (await SentRequestRepository(db).getAll()).single;
    expect(r.sentAt, DateTime(2026, 6, 15, 15, 30));
    expect(r.farmaci.length, 2);

    expect(settings.activeProfileId, 'p1');
    expect(settings.donationCount, 3);
    expect(settings.onboardingShown, isTrue);
    expect(settings.disclaimerAccepted, isTrue);
  });

  test('esporta e ripristina: i dati tornano uguali', () async {
    await service.restoreFromJson(kotlinBackup);
    final json = await service.exportToJson();

    await db.deleteAllData();
    await service.restoreFromJson(json);

    expect((await ProfileRepository(db).getAll()).single.id, 'p1');
    final m = (await MedicationRepository(db).getAll()).single;
    expect(m.orari, ['08:00', '20:00']);
    expect(m.frequenzaTipo, FrequencyUnit.ore);
    final r = (await SentRequestRepository(db).getAll()).single;
    expect(r.sentAt, DateTime(2026, 6, 15, 15, 30));
    expect(settings.donationCount, 3);
  });

  test('il ripristino sostituisce i dati esistenti', () async {
    final profiles = ProfileRepository(db);
    await profiles.save(Profile(id: 'vecchio'));
    await MedicationRepository(db)
        .save(Medication(id: 'v', profileId: 'vecchio', nome: 'Vecchio'));

    await service.restoreFromJson(kotlinBackup);

    expect((await profiles.getAll()).map((p) => p.id), ['p1']);
    expect((await MedicationRepository(db).getAll()).map((m) => m.id), ['m1']);
  });

  test('elementi collegati a profili mancanti vengono scartati e contati',
      () async {
    const json = '''
{
  "version": 1,
  "profiles": [{"id": "p1"}],
  "medications": [
    {"id": "a", "profileId": "p1", "nome": "Buono"},
    {"id": "b", "profileId": "sconosciuto", "nome": "Orfano"}
  ],
  "sentRequests": [
    {"id": "r", "profileId": "sconosciuto", "data": "", "farmaciSerialized": ""}
  ]
}''';
    final result = await service.restoreFromJson(json);
    expect(result.medications, 1);
    expect(result.sentRequests, 0);
    expect(result.skipped, 2);
  });

  test('file non valido: errore e dati attuali intatti', () async {
    await ProfileRepository(db).save(Profile(id: 'resta'));
    await settings.setActiveProfileId('resta');

    expect(() => service.restoreFromJson('non json'), throwsFormatException);
    await expectLater(
        service.restoreFromJson('{"version": 99}'), throwsFormatException);

    expect((await ProfileRepository(db).getAll()).single.id, 'resta');
    expect(settings.activeProfileId, 'resta');
  });

  test('archivio senza profili: nessun profilo attivo', () async {
    await settings.setActiveProfileId('x');
    await service.restoreFromJson('{"version": 1}');
    expect(settings.activeProfileId, isNull);
  });
}
