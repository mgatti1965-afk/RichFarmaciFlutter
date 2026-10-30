import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/app/backup_controller.dart';
import 'package:richfarmaci/app/medication_controller.dart';
import 'package:richfarmaci/app/profile_controller.dart';
import 'package:richfarmaci/app/providers.dart';
import 'package:richfarmaci/app/request_controller.dart';
import 'package:richfarmaci/app/state_providers.dart';
import 'package:richfarmaci/services/archive_file_service.dart';

import 'app_helpers.dart';
import 'fixtures.dart';

void main() {
  late TestEnv env;

  setUp(() async {
    env = await TestEnv.create();
    await env.container.read(profileControllerProvider).saveSettings(
        validSettings().copyWith(messaggioTesta: 'Salve', messaggioCoda: 'Grazie'));
    await env.settle();
  });

  tearDown(() => env.dispose());

  group('invio della richiesta', () {
    Future<void> selectOne() async {
      final med = (await env.container
          .read(medicationControllerProvider)
          .add(nome: 'Lasix', scatole: 2))!;
      env.container.read(requestSelectionProvider.notifier).toggle(med);
    }

    test('apre l\'app e salva nello storico solo se si e\' aperta', () async {
      await selectOne();
      final sent = await env.container.read(requestControllerProvider).sendRequest();
      await env.settle();

      expect(sent, isNotNull);
      expect(env.links.opened.length, 1);
      expect(env.links.opened.single,
          startsWith('https://api.whatsapp.com/send?phone=393331&text='));
      expect(env.container.read(historyProvider).value!.length, 1);
      expect(env.container.read(requestSelectionProvider).isEmpty, isTrue);
    });

    test('se l\'app non si apre: niente storico e selezione intatta', () async {
      await selectOne();
      env.links.succeeds = false;

      final sent = await env.container.read(requestControllerProvider).sendRequest();
      await env.settle();

      expect(sent, isNull);
      expect(env.links.opened.length, 1);
      expect(env.container.read(historyProvider).value, isEmpty);
      expect(env.container.read(requestSelectionProvider).isEmpty, isFalse);
    });

    test('senza profilo attivo non apre nulla', () async {
      await env.container.read(activeProfileIdProvider.notifier).select(null);
      final requests = env.container.read(requestControllerProvider);
      expect(await requests.sendRequest(), isNull);
      expect(await requests.openSendApp('x'), isFalse);
      expect(env.links.opened, isEmpty);
    });
  });

  group('archivio su file', () {
    test('esporta: nome con la data e contenuto dell\'archivio', () async {
      final outcome =
          await env.container.read(backupControllerProvider).exportToFile();
      expect(outcome, ArchiveShareOutcome.completed);
      expect(env.files.sharedName, 'RichFarmaci_Archivio_2026-06-15.json');
      expect(env.files.sharedJson, contains('"version": 2'));
      expect(env.files.sharedJson, contains('RSSMRA40A01H501Z'));
    });

    test('importa: ripristina il file scelto', () async {
      env.files.textToPick = kotlinBackup;
      final result =
          await env.container.read(backupControllerProvider).importFromFile();
      await env.settle();

      expect(result!.profiles, 1);
      expect(env.container.read(activeProfileProvider)!.pazienteNome, 'Mario Rossi');
    });

    test('importa: se l\'utente annulla non cambia nulla', () async {
      env.files.textToPick = null;
      final before = env.container.read(activeProfileIdProvider);
      expect(
          await env.container.read(backupControllerProvider).importFromFile(),
          isNull);
      expect(env.container.read(activeProfileIdProvider), before);
    });

    test('importa: file non valido -> errore chiaro, dati intatti', () async {
      env.files.textToPick = 'non è un archivio';
      await expectLater(
        env.container.read(backupControllerProvider).importFromFile(),
        throwsA(isA<FormatException>()),
      );
      expect(await env.container.read(profileRepositoryProvider).getAll(),
          hasLength(1));
    });
  });
}
