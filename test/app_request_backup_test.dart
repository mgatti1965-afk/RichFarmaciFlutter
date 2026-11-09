import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/app/backup_controller.dart';
import 'package:richfarmaci/app/flags_providers.dart';
import 'package:richfarmaci/app/medication_controller.dart';
import 'package:richfarmaci/app/profile_controller.dart';
import 'package:richfarmaci/app/providers.dart';
import 'package:richfarmaci/app/request_controller.dart';
import 'package:richfarmaci/app/state_providers.dart';

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

  group('richiesta', () {
    test('compone il messaggio, lo salva nello storico e svuota la scelta',
        () async {
      final med = (await env.container
          .read(medicationControllerProvider)
          .add(nome: 'Lasix', scatole: 4, note: 'a digiuno'))!;
      env.container.read(requestSelectionProvider.notifier).toggle(med);
      env.container.read(requestSelectionProvider.notifier).setNote(med.id, 'urgente');

      final requests = env.container.read(requestControllerProvider);
      final text = (await requests.buildMessage())!;
      expect(text, contains('- Lasix: 4 scatole (a digiuno - urgente)'));
      expect(text, startsWith('Salve'));
      expect(text, endsWith('Grazie'));

      final sent = (await requests.recordSent(text))!;
      await env.settle();

      expect(sent.sentAt, testNow);
      expect(sent.testoCompleto, text);
      expect(sent.farmaci.single.note, 'a digiuno - urgente');
      expect(env.container.read(requestSelectionProvider).isEmpty, isTrue);
      expect(env.container.read(historyProvider).value!.single.id, sent.id);
    });

    test('link di invio secondo il canale (WhatsApp di default)', () async {
      final uri = await env.container.read(requestControllerProvider).buildSendUri('Ciao');
      expect(uri, 'https://api.whatsapp.com/send?phone=393331&text=Ciao');
    });

    test('messaggio veloce con i dati del paziente', () async {
      final text = await env.container.read(requestControllerProvider).buildQuickMessage('Ok?');
      expect(text, 'Messaggio da Mario (CF: RSSMRA40A01H501Z):\n\nOk?');
    });

    test('senza profilo attivo tutto restituisce null', () async {
      await env.container.read(activeProfileIdProvider.notifier).select(null);
      final requests = env.container.read(requestControllerProvider);
      expect(await requests.buildMessage(), isNull);
      expect(await requests.buildSendUri('x'), isNull);
      expect(await requests.recordSent('x'), isNull);
    });

    test('elimina una voce dello storico', () async {
      final requests = env.container.read(requestControllerProvider);
      final sent = (await requests.recordSent('t'))!;
      await requests.deleteHistoryItem(sent.id);
      await env.settle();
      expect(env.container.read(historyProvider).value, isEmpty);
    });
  });

  group('archivio', () {
    test('nome file configurazione fisso e univoco', () {
      expect(env.container.read(backupControllerProvider).suggestedFileName(),
          'RichFarmaci_Configurazione.json');
    });

    test('ripristino del backup Kotlin: profilo attivo, preferenze e promemoria',
        () async {
      final backup = env.container.read(backupControllerProvider);
      final result = await backup.restoreJson(kotlinBackup);
      await env.settle();

      expect(result.profiles, 1);
      expect(env.container.read(activeProfileIdProvider), 'p1');
      expect(env.container.read(donationCountProvider), 3);
      expect(env.container.read(onboardingShownProvider), isTrue);
      expect(env.scheduler.cancelAllCount, 1);
      expect(env.scheduler.scheduled, contains('m1'));
      expect(env.container.read(activeProfileProvider)!.pazienteNome, 'Mario Rossi');
    });

    test('file non valido: errore chiaro e dati intatti', () async {
      final before = env.container.read(activeProfileIdProvider);
      await expectLater(
        env.container.read(backupControllerProvider).restoreJson('non json'),
        throwsA(isA<FormatException>()),
      );
      expect(env.container.read(activeProfileIdProvider), before);
      expect(await env.container.read(profileRepositoryProvider).getAll(), hasLength(1));
    });

    test('esporta e rilegge', () async {
      final json = await env.container.read(backupControllerProvider).exportJson();
      expect(json, contains('"version": 2'));
      expect(json, contains('RSSMRA40A01H501Z'));
    });
  });

  group('preferenze', () {
    test('contatore donazioni e flag si aggiornano e si salvano', () async {
      await env.container.read(donationCountProvider.notifier).increment();
      await env.container.read(disclaimerAcceptedProvider.notifier).set(true);
      expect(env.container.read(donationCountProvider), 1);
      expect(env.settings.donationCount, 1);
      expect(env.container.read(disclaimerAcceptedProvider), isTrue);
      expect(env.settings.disclaimerAccepted, isTrue);
    });
  });
}
