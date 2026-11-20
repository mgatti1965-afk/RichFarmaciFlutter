import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/app/profile_controller.dart';
import 'package:richfarmaci/app/providers.dart';
import 'package:richfarmaci/app/state_providers.dart';
import 'package:richfarmaci/app/web_mode.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/patient_settings.dart';
import 'package:richfarmaci/services/contact_picker_service.dart';
import 'package:richfarmaci/ui/screens/settings_screen.dart';
import 'package:richfarmaci/ui/theme/app_theme.dart';

import 'app_helpers.dart';

class _FakeContactPickerService implements ContactPickerService {
  PickedDoctorContact? contactToReturn;
  Object? errorToThrow;

  @override
  Future<PickedDoctorContact?> pickContact() async {
    if (errorToThrow != null) throw errorToThrow!;
    return contactToReturn;
  }
}

Future<TestEnv> _createSettingsEnv(
  _FakeContactPickerService fakePicker, {
  bool isWeb = false,
}) async {
  final env = await TestEnv.create(
    extraOverrides: [
      contactPickerServiceProvider.overrideWithValue(fakePicker),
      if (isWeb) isWebModeProvider.overrideWithValue(true),
    ],
  );
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
  return env;
}

void main() {
  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  group('SettingsScreen importazione medico dalla Rubrica:', () {
    late TestEnv env;
    late _FakeContactPickerService fakePicker;

    setUp(() async {
      fakePicker = _FakeContactPickerService();
      env = await _createSettingsEnv(fakePicker);
    });

    tearDown(() async {
      await env.dispose();
    });

    testWidgets('importa nome, telefono, email e indirizzo dal contatto scelto',
        (tester) async {
      fakePicker.contactToReturn = const PickedDoctorContact(
        name: 'Dott.ssa Elena Verdi',
        phone: '+39 347 9876543',
        email: 'elena.verdi@studio.it',
        address: 'Via Garibaldi 12, Milano',
      );

      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: env.container,
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.text('Dalla Rubrica');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      TextField fieldByLabel(String label) => tester.widget<TextField>(
            find.widgetWithText(TextField, label),
          );

      expect(fieldByLabel('Nome del Medico *').controller?.text,
          'Dott.ssa Elena Verdi');
      expect(
          fieldByLabel('Telefono Medico (per WhatsApp o SMS)').controller?.text,
          '+39 347 9876543');
      expect(fieldByLabel('Email Medico (per Email)').controller?.text,
          'elena.verdi@studio.it');
      expect(fieldByLabel('Indirizzo Studio (Opzionale)').controller?.text,
          'Via Garibaldi 12, Milano');

      final saveButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'SALVA CONFIGURAZIONE'),
      );
      expect(saveButton.style?.backgroundColor?.resolve({}),
          AppColors.redDanger);
    });

    testWidgets('annullamento del picker lascia i dati invariati',
        (tester) async {
      fakePicker.contactToReturn = null;

      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: env.container,
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dalla Rubrica'));
      await tester.pumpAndSettle();

      final nomeField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Nome del Medico *'),
      );
      expect(nomeField.controller?.text, 'Dott. Bianchi');
    });

    testWidgets('permesso negato mostra un messaggio di errore',
        (tester) async {
      fakePicker.errorToThrow = const ContactPermissionDeniedException();

      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: env.container,
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dalla Rubrica'));
      await tester.pumpAndSettle();

      expect(
        find.text('Permesso rubrica necessario per importare un contatto.'),
        findsOneWidget,
      );
    });
  });

  group('SettingsScreen importazione medico in modalita Web:', () {
    late TestEnv env;

    setUp(() async {
      env = await _createSettingsEnv(_FakeContactPickerService(), isWeb: true);
    });

    tearDown(() async {
      await env.dispose();
    });

    testWidgets('in modalita Web il pulsante Dalla Rubrica e nascosto',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: env.container,
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dalla Rubrica'), findsNothing);
    });
  });
}
