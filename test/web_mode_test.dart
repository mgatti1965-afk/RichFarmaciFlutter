import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/app/flags_providers.dart';
import 'package:richfarmaci/app/medication_controller.dart';
import 'package:richfarmaci/app/profile_controller.dart';
import 'package:richfarmaci/app/request_controller.dart';
import 'package:richfarmaci/app/state_providers.dart';
import 'package:richfarmaci/app/web_mode.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/ui/screens/main_screen.dart';
import 'package:richfarmaci/ui/screens/medication_editor_sheet.dart';
import 'package:richfarmaci/ui/screens/settings_screen.dart';
import 'package:richfarmaci/ui/screens/web_mode_reminder_info_screen.dart';
import 'package:richfarmaci/ui/theme/app_theme.dart';
import 'package:richfarmaci/ui/widgets/web_mode_banner.dart';

import 'app_helpers.dart';

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  group('Web Mode: Test di accettazione unificati', () {
    late TestEnv env;

    setUp(() async {
      env = await TestEnv.create(
        extraOverrides: [isWebModeProvider.overrideWithValue(true)],
      );
      await env.db.customSelect('SELECT 1').get();
    });

    tearDown(() async {
      await env.dispose();
    });

    Widget buildTestApp({Widget? home, String? initialRoute}) {
      return UncontrolledProviderScope(
        container: env.container,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          initialRoute: initialRoute,
          routes: {
            if (home == null) '/': (_) => const MainScreen(),
            '/promemoria': (_) => const WebModeReminderInfoScreen(),
            '/reminder': (_) => const WebModeReminderInfoScreen(),
          },
          home: home,
        ),
      );
    }

    testWidgets('Banner Web Mode rimosso da MainScreen e SettingsScreen', (tester) async {
      await env.container.read(disclaimerAcceptedProvider.notifier).set(true);
      await env.container.read(onboardingShownProvider.notifier).set(true);

      await tester.pumpWidget(buildTestApp(home: const MainScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(WebModeBanner), findsNothing);
      expect(
        find.text('Versione web: promemoria automatici non disponibili.'),
        findsNothing,
      );

      await tester.pumpWidget(buildTestApp(home: const SettingsScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(WebModeBanner), findsNothing);
      expect(
        find.text('Versione web: promemoria automatici non disponibili.'),
        findsNothing,
      );
    });

    testWidgets('Senza pazienti all\'avvio naviga automaticamente a SettingsScreen', (tester) async {
      await env.container.read(disclaimerAcceptedProvider.notifier).set(true);
      await env.container.read(onboardingShownProvider.notifier).set(true);

      await tester.pumpWidget(buildTestApp());
      await tester.pump();
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('Pulsanti Nuovo Farmaco e Aggiungi Farmaco non presenti in MainScreen', (tester) async {
      await env.container.read(disclaimerAcceptedProvider.notifier).set(true);
      await env.container.read(onboardingShownProvider.notifier).set(true);
      await tester.runAsync(() async {
        final p = await env.container
            .read(profileControllerProvider)
            .saveSettings(validSettings());
        await env.container.read(activeProfileIdProvider.notifier).select(p.id);
        await env.settle();
      });

      await tester.pumpWidget(buildTestApp(home: const MainScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('AGGIUNGI FARMACO'), findsNothing);
      expect(find.text('Nuovo Farmaco'), findsNothing);
      expect(find.text('Messaggio Veloce'), findsOneWidget);
    });

    testWidgets(
      'Controlli promemoria disabilitati in SettingsScreen con spiegazione visibile',
      (tester) async {
        await tester.pumpWidget(buildTestApp(home: const SettingsScreen()));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Scroll fino alla sezione promemoria
        final switchFinder = find.widgetWithText(
          SwitchListTile,
          'Promemoria Notifiche',
        );
        await tester.scrollUntilVisible(
          switchFinder,
          50,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pump();

        // Spiegazione visibile sotto lo switch
        expect(
          find.text(
            'Funzione disponibile solo nelle versioni native Android e iOS.',
          ),
          findsOneWidget,
        );

        // Lo SwitchListTile per le notifiche ha onChanged = null in web mode
        expect(switchFinder, findsOneWidget);
        final switchWidget = tester.widget<SwitchListTile>(switchFinder);
        expect(switchWidget.onChanged, isNull);

        // Nessun pulsante extra "Dettagli disponibilita"
        expect(find.text('Dettagli disponibilita'), findsNothing);
      },
    );

    testWidgets('Controlli promemoria disabilitati in MedicationEditorSheet', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(home: const MedicationEditorSheet()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // La schermata rimane uguale: lo switch c'è ma è disabilitato
      final switchFinder = find.widgetWithText(
        SwitchListTile,
        'Promemoria Notifica',
      );
      expect(switchFinder, findsOneWidget);
      final switchWidget = tester.widget<SwitchListTile>(switchFinder);
      expect(switchWidget.onChanged, isNull);

      // Nessuna segnalazione o pulsante extra dentro l'editor farmaci
      expect(
        find.text(
          'Funzione disponibile solo nelle versioni native Android e iOS.',
        ),
        findsNothing,
      );
      expect(find.text('Dettagli disponibilita'), findsNothing);
    });

    test('Aggiunta farmaco in Web Mode forza promemoria disattivati', () async {
      final p = await env.container
          .read(profileControllerProvider)
          .saveSettings(validSettings());
      await env.container.read(activeProfileIdProvider.notifier).select(p.id);

      final med = await env.container
          .read(medicationControllerProvider)
          .add(
            nome: 'Tachipirina 1000',
            notificaAttiva: true, // L'utente tenta di attivarla
          );

      expect(med, isNotNull);
      expect(med!.notificaAttiva, isFalse);
      expect(env.scheduler.scheduled, isEmpty);
      expect(env.telemetry.has('web_reminder_action_blocked'), isTrue);
    });

    test(
      'Salvataggio profilo in Web Mode forza notificheAttive a false',
      () async {
        final p = await env.container
            .read(profileControllerProvider)
            .saveSettings(validSettings(notifiche: true));

        expect(p.notificheAttive, isFalse);
        expect(env.telemetry.has('web_reminder_action_blocked'), isTrue);
      },
    );

    testWidgets(
      'Route diretta /promemoria o /reminder mostra schermata informativa senza crash',
      (tester) async {
        await tester.pumpWidget(buildTestApp(initialRoute: '/promemoria'));
        await tester.pumpAndSettle();

        expect(find.byType(WebModeReminderInfoScreen), findsOneWidget);
        expect(
          find.text(
            'Funzione disponibile solo nelle versioni native Android e iOS.',
          ),
          findsOneWidget,
        );
        expect(find.text('Torna alla Home'), findsOneWidget);
        expect(env.telemetry.has('web_reminder_action_blocked'), isTrue);

        // Cliccando su Torna alla Home naviga verso / senza errori
        await tester.tap(find.text('Torna alla Home'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(MainScreen), findsOneWidget);
      },
    );

    testWidgets(
      'Errore export in Web Mode mostra messaggio non tecnico e traccia telemetria',
      (tester) async {
        env.files.throwOnShare = true;

        await tester.pumpWidget(buildTestApp(home: const SettingsScreen()));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Scroll fino al pulsante "Esporta"
        await tester.scrollUntilVisible(
          find.text('Esporta'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.ensureVisible(find.text('Esporta'));
        await tester.pump();
        await tester.tap(find.text('Esporta'));
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        });
        await tester.pumpAndSettle();

        // Verifica messaggio utente chiaro senza dettagli tecnici
        expect(find.text('Operazione non riuscita, riprova.'), findsOneWidget);
        expect(env.telemetry.has('export_failed_web'), isTrue);
      },
    );

    testWidgets(
      'Errore backup import in Web Mode mostra messaggio non tecnico e traccia telemetria',
      (tester) async {
        env.files.throwOnPick = true;

        await tester.pumpWidget(buildTestApp(home: const SettingsScreen()));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Scroll fino al pulsante "Importa"
        await tester.scrollUntilVisible(
          find.text('Importa'),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('Importa'));
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        });
        await tester.pumpAndSettle();

        // Verifica messaggio utente chiaro
        expect(find.text('Operazione non riuscita, riprova.'), findsOneWidget);
        expect(env.telemetry.has('backup_failed_web'), isTrue);
      },
    );

    group('Compatibilità Web iOS (Safari iPhone / iPad)', () {
      test(
        'SMS link per iOS usa il separatore &body= conforme ad Apple Safari',
        () async {
          final profile = await env.container
              .read(profileControllerProvider)
              .saveSettings(
                validSettings().copyWith(
                  tipoInvio: SendChannel.sms,
                  medicoTelefono: '+393331234567',
                ),
              );
          await env.container
              .read(activeProfileIdProvider.notifier)
              .select(profile.id);

          final requestCtrl = env.container.read(requestControllerProvider);
          final uriString = await requestCtrl.buildSendUri(
            'Messaggio di prova',
            ios: true,
          );

          expect(uriString, isNotNull);
          expect(uriString, startsWith('sms:+393331234567&body='));
          expect(
            uriString,
            contains(Uri.encodeComponent('Messaggio di prova')),
          );
        },
      );

      test('SMS link per non-iOS usa il separatore standard ?body=', () async {
        final profile = await env.container
            .read(profileControllerProvider)
            .saveSettings(
              validSettings().copyWith(
                tipoInvio: SendChannel.sms,
                medicoTelefono: '+393331234567',
              ),
            );
        await env.container
            .read(activeProfileIdProvider.notifier)
            .select(profile.id);

        final requestCtrl = env.container.read(requestControllerProvider);
        final uriString = await requestCtrl.buildSendUri(
          'Messaggio di prova',
          ios: false,
        );

        expect(uriString, isNotNull);
        expect(uriString, startsWith('sms:+393331234567?body='));
      });

      test(
        'WhatsApp link per Safari iOS pulisce il numero e codifica il testo',
        () async {
          final profile = await env.container
              .read(profileControllerProvider)
              .saveSettings(
                validSettings().copyWith(
                  tipoInvio: SendChannel.whatsapp,
                  medicoTelefono: '+39 333 123 4567',
                ),
              );
          await env.container
              .read(activeProfileIdProvider.notifier)
              .select(profile.id);

          final requestCtrl = env.container.read(requestControllerProvider);
          final uriString = await requestCtrl.buildSendUri(
            'Richiesta Cardioaspirina',
          );

          expect(uriString, isNotNull);
          expect(
            uriString,
            startsWith(
              'https://api.whatsapp.com/send?phone=393331234567&text=',
            ),
          );
          expect(uriString, contains('Cardioaspirina'));
        },
      );

      test(
        'Invio messaggio traccia successo e fallimento in telemetria',
        () async {
          final profile = await env.container
              .read(profileControllerProvider)
              .saveSettings(validSettings());
          await env.container
              .read(activeProfileIdProvider.notifier)
              .select(profile.id);

          final requestCtrl = env.container.read(requestControllerProvider);

          // Successo
          env.links.succeeds = true;
          final sentOk = await requestCtrl.openSendApp('Test');
          expect(sentOk, isTrue);
          expect(env.telemetry.has('message_sent_to_doctor'), isTrue);

          // Fallimento canale
          env.links.succeeds = false;
          final sentFail = await requestCtrl.openSendApp('Test');
          expect(sentFail, isFalse);
          expect(env.telemetry.has('message_send_failed'), isTrue);
        },
      );
    });
  });
}
