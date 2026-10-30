import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/data/db/app_database.dart';
import 'package:richfarmaci/data/models/medication.dart';
import 'package:richfarmaci/data/models/profile.dart';
import 'package:richfarmaci/data/models/sent_medication.dart';
import 'package:richfarmaci/data/models/sent_request.dart';
import 'package:richfarmaci/data/repositories/medication_repository.dart';
import 'package:richfarmaci/data/repositories/profile_repository.dart';
import 'package:richfarmaci/data/repositories/sent_request_repository.dart';

void main() {
  late AppDatabase db;
  late ProfileRepository profiles;
  late MedicationRepository meds;
  late SentRequestRepository requests;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    profiles = ProfileRepository(db);
    meds = MedicationRepository(db);
    requests = SentRequestRepository(db);
  });

  tearDown(() => db.close());

  SentRequest req(String id, String profileId, DateTime at) => SentRequest(
        id: id,
        profileId: profileId,
        sentAt: at,
        pazienteNome: 'M',
        medicoNome: 'D',
        farmaci: const [SentMedication(nome: 'A', scatole: 2, note: 'n')],
        testoCompleto: 't',
      );

  group('storico', () {
    setUp(() async => profiles.save(Profile(id: 'p1')));

    test('dal piu\' recente, qualunque sia l\'ordine di inserimento',
        () async {
      await requests.save(req('b', 'p1', DateTime(2026, 2, 1)));
      await requests.save(req('c', 'p1', DateTime(2026, 3, 1)));
      await requests.save(req('a', 'p1', DateTime(2026, 1, 1)));

      final list = await requests.watchByProfile('p1').first;
      expect(list.map((r) => r.id), ['c', 'b', 'a']);
    });

    test('i farmaci inviati si rileggono uguali', () async {
      await requests.save(req('a', 'p1', DateTime(2026, 1, 1)));
      final r = (await requests.getAll()).single;
      expect(r.farmaci.single,
          const SentMedication(nome: 'A', scatole: 2, note: 'n'));
      expect(r.sentAt, DateTime(2026, 1, 1));
    });

    test('elimina una richiesta', () async {
      await requests.save(req('a', 'p1', DateTime(2026, 1, 1)));
      await requests.delete('a');
      expect(await requests.getAll(), isEmpty);
    });
  });

  group('cancellazione a cascata', () {
    test('cancellando un profilo spariscono farmaci e storico', () async {
      await profiles.save(Profile(id: 'p1'));
      await profiles.save(Profile(id: 'p2'));
      await meds.save(Medication(id: '1', profileId: 'p1', nome: 'A'));
      await meds.save(Medication(id: '2', profileId: 'p2', nome: 'B'));
      await requests.save(req('r1', 'p1', DateTime(2026, 1, 1)));
      await requests.save(req('r2', 'p2', DateTime(2026, 1, 1)));

      await profiles.delete('p1');

      expect((await meds.getAll()).map((m) => m.id), ['2']);
      expect((await requests.getAll()).map((r) => r.id), ['r2']);
      expect((await profiles.getAll()).map((p) => p.id), ['p2']);
    });

    test('deleteAllData svuota tutto', () async {
      await profiles.save(Profile(id: 'p1'));
      await meds.save(Medication(id: '1', profileId: 'p1', nome: 'A'));
      await requests.save(req('r1', 'p1', DateTime(2026, 1, 1)));

      await db.deleteAllData();

      expect(await profiles.getAll(), isEmpty);
      expect(await meds.getAll(), isEmpty);
      expect(await requests.getAll(), isEmpty);
    });
  });
}
