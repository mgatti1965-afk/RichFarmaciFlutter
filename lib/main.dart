import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'app/providers.dart';
import 'app/profile_controller.dart';
import 'app/web_mode.dart';
import 'data/db/app_database.dart';
import 'data/db/open_connection.dart';
import 'data/settings_store.dart';
import 'services/archive_file_service.dart';
import 'services/link_opener.dart';
import 'services/local_reminder_scheduler.dart';
import 'services/reminder_scheduler.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/web_mode_reminder_info_screen.dart';
import 'ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza preferenze e persistenza SQLite
  final settingsStore = await SettingsStore.open();
  final appDatabase = AppDatabase(openAppConnection());

  // In web mode i promemoria sono sempre disattivati.
  final bool isWebMode = kIsWeb;

  final ReminderScheduler reminderScheduler;
  if (isWebMode) {
    reminderScheduler = const NoopReminderScheduler();
  } else {
    final local = LocalReminderScheduler();
    await local.init();
    reminderScheduler = local;
  }

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
  bool _telemetryBootTracked = false;

  @override
  void initState() {
    super.initState();
    // All'avvio dell'app allinea il profilo attivo salvato
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider).initialize();
      if (!_telemetryBootTracked && ref.read(isWebModeProvider)) {
        ref.read(telemetryProvider).track('web_mode_opened');
        _telemetryBootTracked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichFarmaci',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute<void>(
              builder: (_) => const MainScreen(),
              settings: settings,
            );
          case '/promemoria':
          case '/reminder':
            if (!ref.read(isWebModeProvider)) {
              return MaterialPageRoute<void>(
                builder: (_) => const MainScreen(),
                settings: settings,
              );
            }
            return MaterialPageRoute<void>(
              builder: (_) => const WebModeReminderInfoScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute<void>(
              builder: (_) => const MainScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}
