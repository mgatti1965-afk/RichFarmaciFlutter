import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/app/flags_providers.dart';
import 'package:richfarmaci/app/medication_controller.dart';
import 'package:richfarmaci/app/profile_controller.dart';
import 'package:richfarmaci/app/state_providers.dart';
import 'package:richfarmaci/ui/screens/disclaimer_dialog.dart';
import 'package:richfarmaci/ui/screens/main_screen.dart';
import 'package:richfarmaci/ui/screens/onboarding_dialog.dart';
import 'package:richfarmaci/ui/theme/app_theme.dart';

import 'app_helpers.dart';

void main() {
  late TestEnv env;

  setUp(() async {
    env = await TestEnv.create();
  });

  tearDown(() async {
    await env.dispose();
  });

  Widget buildTestApp() {
    return UncontrolledProviderScope(
      container: env.container,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }

  testWidgets('Mostra Disclaimer iniziale al primo avvio', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(DisclaimerDialog), findsOneWidget);
    expect(find.text('ACCETTO E CONTINUA'), findsOneWidget);

    // Tocca accetto
    await tester.tap(find.text('ACCETTO E CONTINUA'));
    await tester.pumpAndSettle();

    // Ora mostra l'onboarding
    expect(find.byType(OnboardingDialog), findsOneWidget);
    expect(find.text('INIZIA ORA'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Mostra Onboarding e poi schermata principale', (tester) async {
    env.container.read(disclaimerAcceptedProvider.notifier).set(true);

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingDialog), findsOneWidget);
    await tester.tap(find.text('INIZIA ORA'));
    await tester.pumpAndSettle();

    // Entra nella MainScreen
    expect(find.text('RichFarmaci'), findsOneWidget);
    expect(find.text('Richiesta'), findsOneWidget);
    expect(find.text('Cronologia'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Test accessibilità per anziani: textScaleFactor 2.0',
      (tester) async {
    env.container.read(disclaimerAcceptedProvider.notifier).set(true);
    env.container.read(onboardingShownProvider.notifier).set(true);

    // Salva un profilo e dei farmaci
    final p = await env.container
        .read(profileControllerProvider)
        .saveSettings(validSettings());
    await env.container.read(activeProfileIdProvider.notifier).select(p.id);
    await env.container
        .read(medicationControllerProvider)
        .add(nome: 'Cardioaspirina', scatole: 1);
    await env.settle();

    // Configura textScaleFactor = 2.0 (200%)
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;

    await tester.pumpWidget(buildTestApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('RichFarmaci'), findsOneWidget);
    expect(find.text('Cardioaspirina'), findsOneWidget);

    // Verifica che toccando la card si selezioni il farmaco e compaia il tasto di invio
    await tester.tap(find.text('Cardioaspirina'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('INVIA RICHIESTA AL MEDICO'), findsOneWidget);

    // Reset scala testo e smonta widget
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    await tester.pumpWidget(const SizedBox());
  });
}
