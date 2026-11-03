import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/profile_controller.dart';
import 'app/providers.dart';
import 'data/db/app_database.dart';
import 'data/db/open_connection.dart';
import 'data/settings_store.dart';
import 'services/archive_file_service.dart';
import 'services/link_opener.dart';
import 'services/local_reminder_scheduler.dart';
import 'ui/screens/main_screen.dart';
import 'ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza preferenze e persistenza SQLite
  final settingsStore = await SettingsStore.open();
  final appDatabase = AppDatabase(openAppConnection());

  // Inizializza notifiche locali e fuso orario
  final reminderScheduler = LocalReminderScheduler();
  await reminderScheduler.init();

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(appDatabase),
        settingsStoreProvider.overrideWithValue(settingsStore),
        reminderSchedulerProvider.overrideWithValue(reminderScheduler),
        linkOpenerProvider.overrideWithValue(const UrlLauncherOpener()),
        archiveFileServiceProvider.overrideWithValue(const DeviceArchiveFileService()),
      ],
      child: const RichFarmaciApp(),
    ),
  );
}

class RichFarmaciApp extends ConsumerStatefulWidget {
  const RichFarmaciApp({super.key});

  @override
  ConsumerState<RichFarmaciApp> createState() => _RichFarmaciAppState();
}

class _RichFarmaciAppState extends ConsumerState<RichFarmaciApp> {
  @override
  void initState() {
    super.initState();
    // All'avvio dell'app allinea il profilo attivo salvato
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichFarmaci',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
