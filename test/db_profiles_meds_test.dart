import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/data/db/app_database.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/medication.dart';
import 'package:richfarmaci/data/models/profile.dart';
import 'package:richfarmaci/data/repositories/medication_repository.dart';
import 'package:richfarmaci/data/repositories/profile_repository.dart';

void main() {
  late AppDatabase db;
  late ProfileRepository profiles;
  late MedicationRepository meds;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    profiles = ProfileRepository(db);
    meds = MedicationRepository(db);
  });

  tearDown(() => db.close());

  group('profili', () {
    test('salva, rilegge e aggiorna', () async {
      final p = Profile(
        id: 'p1',
        pazienteNome: 'Mario',
        tipoInvio: SendChannel.email,
        notificheAttive: true,
      );
      await profiles.save(p);
      expect(await profiles.getById('p1'), p);

      await profiles.save(Profile(id: 'p1', pazienteNome: 'Luigi'));
      expect((await profiles.getAll()).single.pazienteNome, 'Luigi');
    });

    test('id inesistente -> null', () async {
      expect(await profiles.getById('x'), isNull);
    });

    test('lo stream segue le modifiche', () async {
      final events = <int>[];
      final sub = profiles.watchAll().listen((l) => events.add(l.length));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await profiles.save(Profile(id: 'a'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await profiles.save(Profile(id: 'b'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await sub.cancel();
      expect(events, containsAllInOrder([0, 1, 2]));
    });
  });

  group('farmaci', () {
    setUp(() async {
      await profiles.save(Profile(id: 'p1'));
      await profiles.save(Profile(id: 'p2'));
    });

    test('ordinati per nome e separati per profilo', () async {
      await meds.save(Medication(id: '1', profileId: 'p1', nome: 'Zyloric'));
      await meds.save(Medication(id: '2', profileId: 'p1', nome: 'Aspirina'));
      await meds.save(Medication(id: '3', profileId: 'p2', nome: 'Altro'));

      final list = await meds.getByProfile('p1');
      expect(list.map((m) => m.nome), ['Aspirina', 'Zyloric']);
      expect((await meds.getAll()).length, 3);
    });

    test('tutti i campi sopravvivono al salvataggio', () async {
      final m = Medication(
        id: 'm',
        profileId: 'p1',
        nome: 'Lasix',
        scatole: 4,
        note: 'a digiuno',
        inPausa: true,
        notificaAttiva: true,
        orarioNotifica: '08:00,20:00',
        frequenzaValore: 12,
        frequenzaTipo: FrequencyUnit.ore,
      );
      await meds.save(m);
      expect((await meds.getByProfile('p1')).single, m);
    });

    test('elimina un farmaco', () async {
      await meds.save(Medication(id: '1', profileId: 'p1', nome: 'A'));
      await meds.delete('1');
      expect(await meds.getAll(), isEmpty);
    });

    test('farmaco con profilo inesistente viene rifiutato', () async {
      await expectLater(
        meds.save(Medication(id: '1', profileId: 'nessuno', nome: 'A')),
        throwsA(anything),
      );
    });
  });
}
