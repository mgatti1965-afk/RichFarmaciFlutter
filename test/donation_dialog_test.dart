import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/app/flags_providers.dart';
import 'package:richfarmaci/app/profile_controller.dart';
import 'package:richfarmaci/app/state_providers.dart';
import 'package:richfarmaci/ui/screens/donation_dialog.dart';
import 'package:richfarmaci/ui/screens/main_screen.dart';
import 'package:richfarmaci/ui/screens/settings_screen.dart';
import 'package:richfarmaci/ui/theme/app_theme.dart';
import 'package:richfarmaci/ui/widgets/help_dialog.dart';

import 'app_helpers.dart';

void main() {
  late TestEnv env;

  setUp(() async {
    env = await TestEnv.create();
    await env.container.read(disclaimerAcceptedProvider.notifier).set(true);
    await env.container.read(onboardingShownProvider.notifier).set(true);
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

  testWidgets('Icona tazzina caffè è visibile nell AppBar di MainScreen',
      (tester) async {
    await tester.runAsync(() async {
      final p = await env.container
          .read(profileControllerProvider)
          .saveSettings(validSettings());
      await env.container.read(activeProfileIdProvider.notifier).select(p.id);
      await env.settle();
    });

    await tester.pumpWidget(buildTestApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // L'icona tazzina coffee deve essere presente nella AppBar
    expect(find.byTooltip('Offri un caffè'), findsOneWidget);
    expect(find.text('☕'), findsWidgets);

    // Toccando la tazzina si apre DonationDialog
    await tester.tap(find.byTooltip('Offri un caffè'));
    await tester.pumpAndSettle();

    expect(find.byType(DonationDialog), findsOneWidget);
    expect(find.text('Offri un caffè ☕'), findsOneWidget);
    expect(find.text('SOSTIENI'), findsOneWidget);
    expect(find.text('ANNULLA'), findsOneWidget);

    // Toccando ANNULLA si chiude
    await tester.tap(find.text('ANNULLA'));
    await tester.pumpAndSettle();

    expect(find.byType(DonationDialog), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('DonationDialog mostra avviso se donationCount == 1',
      (tester) async {
    await env.container.read(donationCountProvider.notifier).increment();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: env.container,
        child: const MaterialApp(
          home: Scaffold(body: DonationDialog()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Offri un caffè ☕'), findsOneWidget);
    expect(
      find.text('ATTENZIONE: Hai già sostenuto il progetto in precedenza.'),
      findsOneWidget,
    );
    expect(find.text('SOSTIENI'), findsOneWidget);
  });

  testWidgets('DonationDialog blocca ulteriori donazioni se donationCount >= 2',
      (tester) async {
    await env.container.read(donationCountProvider.notifier).increment();
    await env.container.read(donationCountProvider.notifier).increment();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: env.container,
        child: const MaterialApp(
          home: Scaffold(body: DonationDialog()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Grazie di cuore! ☕'), findsOneWidget);
    expect(
      find.text(
        'Hai già sostenuto il progetto il numero massimo di volte. Ti ringraziamo immensamente per il tuo supporto!',
      ),
      findsOneWidget,
    );
    expect(find.text('CHIUDI'), findsOneWidget);
    expect(find.text('SOSTIENI'), findsNothing);
  });

  testWidgets('DonationDialog attiva modalità TEST sandbox su pressione prolungata',
      (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: env.container,
        child: const MaterialApp(
          home: Scaffold(body: DonationDialog()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Pressione prolungata sul titolo
    await tester.longPress(find.text('Offri un caffè ☕'));
    await tester.pumpAndSettle();

    expect(find.text('Modalità Test Sandbox'), findsOneWidget);

    // Inserisce password errata
    await tester.enterText(find.byType(TextField), 'wrong');
    await tester.tap(find.text('ENTRA'));
    await tester.pumpAndSettle();

    expect(find.text('Password errata'), findsOneWidget);

    // Inserisce password corretta 'Nidama01'
    await tester.enterText(find.byType(TextField), 'Nidama01');
    await tester.tap(find.text('ENTRA'));
    await tester.pumpAndSettle();

    // Ritorna al dialogo con indicatore (TEST)
    expect(find.text('(TEST)'), findsOneWidget);

    // Clicca SOSTIENI in modalità test
    await tester.tap(find.text('SOSTIENI'));
    await tester.pumpAndSettle();

    // Ha aperto sandbox paypal URL e non ha incrementato donationCount
    expect(env.links.opened, hasLength(1));
    expect(env.links.opened.first, contains('sandbox.paypal.com'));
    expect(env.container.read(donationCountProvider), 0);
  });

  testWidgets('DonationDialog lancia PayPal di produzione e incrementa contatore',
      (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: env.container,
        child: const MaterialApp(
          home: Scaffold(body: DonationDialog()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('SOSTIENI'));
    await tester.pumpAndSettle();

    expect(env.links.opened, hasLength(1));
    expect(env.links.opened.first, contains('www.paypal.com'));
    expect(env.links.opened.first, contains('Offerta%20Caffe%20RichFarmaci'));
    expect(env.links.opened.first, contains('marco.gatti65@alice.it'));
    expect(env.container.read(donationCountProvider), 1);
  });

  testWidgets('Testata Configurazione ha simbolo ingranaggio e apre help "?"',
      (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: env.container,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verifica titolo Configurazione con simbolo ingranaggio
    expect(find.text('Configurazione'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsWidgets);

    // Verifica pulsante help ? nella testata
    expect(find.byIcon(Icons.help_outline), findsOneWidget);

    // Toccando ? apre HelpDialog di tipo configurazione
    await tester.tap(find.byIcon(Icons.help_outline));
    await tester.pumpAndSettle();

    expect(find.byType(HelpDialog), findsOneWidget);
    expect(find.text('Guida Configurazione'), findsOneWidget);
    expect(
      find.text(
        'ANAGRAFICA: Inserisci Nome, Cognome, Codice Fiscale del paziente e i dati del Medico curante.',
      ),
      findsOneWidget,
    );

    // Chiude l'help
    await tester.tap(find.text('Ho capito'));
    await tester.pumpAndSettle();

    expect(find.byType(HelpDialog), findsNothing);
  });

  testWidgets('HelpDialog a piede mostra richiamo al manuale e apre il manuale completo',
      (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: env.container,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: HelpDialog(
              type: 'richiesta',
              onDismiss: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // A piede del menu in linea c'è il pulsante per il manuale nelle actions (verde con scritte bianche)
    expect(find.text('Manuale'), findsOneWidget);
    expect(find.text('Apri Manuale Completo'), findsNothing);

    // Toccando 'Manuale' nelle actions apre la vista con il manuale utente Markdown
    await tester.tap(find.text('Manuale'));
    await tester.pumpAndSettle();

    expect(find.text('Manuale Utente'), findsOneWidget);
    expect(find.text('Indietro'), findsOneWidget);

    // Toccando Indietro si torna alla guida rapida
    await tester.tap(find.text('Indietro'));
    await tester.pumpAndSettle();

    expect(find.text('Guida Richiesta Farmaci'), findsOneWidget);
    expect(find.text('Manuale'), findsOneWidget);
  });
}
