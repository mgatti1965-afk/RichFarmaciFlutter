import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/app/profile_controller.dart';
import 'package:richfarmaci/app/state_providers.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/patient_settings.dart';
import 'package:richfarmaci/ui/screens/settings_screen.dart';
import 'package:richfarmaci/ui/theme/app_theme.dart';

import 'app_helpers.dart';

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  group('SettingsScreen pulsante Salva Configurazione:', () {
    late TestEnv env;

    setUp(() async {
      env = await TestEnv.create();
      final p = await env.container.read(profileControllerProvider).saveSettings(
            const PatientSettings(
              pazienteNome: 'Mario Rossi',
              pazienteCf: 'RSSMRA80A01H501U',
              medicoNome: 'Dott. Bianchi',
              medicoTelefono: '3331234567',
              tipoInvio: SendChannel.whatsapp,
            ),
          );
      await env.container.read(activeProfileIdProvider.notifier).select(p.id);
      await env.settle();
    });

    tearDown(() async {
      await env.dispose();
    });

    testWidgets('inizialmente verde, diventa rosso alla modifica e torna verde dopo il salvataggio', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: env.container,
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final saveButtonFinder = find.widgetWithText(ElevatedButton, 'SALVA CONFIGURAZIONE');
      expect(saveButtonFinder, findsOneWidget);

      ElevatedButton getButton() => tester.widget<ElevatedButton>(saveButtonFinder);

      // Inizialmente VERDE (nessuna modifica)
      expect(getButton().style?.backgroundColor?.resolve({}), AppColors.greenPrimary);

      // Modifica nome paziente
      final nomeField = find.widgetWithText(TextField, 'Nome e Cognome Paziente *');
      await tester.enterText(nomeField, 'Mario Verdi');
      await tester.pump();

      // Ora diventa ROSSO (c'è una modifica non salvata)
      expect(getButton().style?.backgroundColor?.resolve({}), AppColors.redDanger);

      // Tap su SALVA CONFIGURAZIONE
      await tester.tap(saveButtonFinder);
      await tester.pump();
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Dopo il salvataggio torna VERDE
      expect(getButton().style?.backgroundColor?.resolve({}), AppColors.greenPrimary);

      // Verifica che la modifica sia stata salvata
      final updatedProfile = env.container.read(activeProfileProvider);
      expect(updatedProfile?.pazienteNome, 'Mario Verdi');
    });
  });
}
