import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/backup_service.dart';
import '../data/db/app_database.dart';
import '../data/repositories/medication_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/sent_request_repository.dart';
import '../data/settings_store.dart';
import '../services/archive_file_service.dart';
import '../services/link_opener.dart';
import '../services/reminder_scheduler.dart';

/// Database e preferenze vanno forniti all'avvio dell'app (e nei test)
/// con `overrideWithValue`: finche' non lo si fa, usarli e' un errore.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(
    'appDatabaseProvider va sostituito all\'avvio (override).',
  ),
);

final settingsStoreProvider = Provider<SettingsStore>(
  (ref) => throw UnimplementedError(
    'settingsStoreProvider va sostituito all\'avvio (override).',
  ),
);

/// Orologio dell'app: nei test si sostituisce con un'ora fissa.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Promemoria. Qui c'e' la versione vuota (usata nei test); all'avvio
/// dell'app va sostituita con LocalReminderScheduler tramite override.
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => const NoopReminderScheduler(),
);

/// Apertura di WhatsApp, SMS ed email. Nei test si sostituisce.
final linkOpenerProvider = Provider<LinkOpener>(
  (ref) => const UrlLauncherOpener(),
);

/// Salvataggio e scelta del file di archivio. Nei test si sostituisce.
final archiveFileServiceProvider = Provider<ArchiveFileService>(
  (ref) => const DeviceArchiveFileService(),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(appDatabaseProvider)),
);

final medicationRepositoryProvider = Provider<MedicationRepository>(
  (ref) => MedicationRepository(ref.watch(appDatabaseProvider)),
);

final sentRequestRepositoryProvider = Provider<SentRequestRepository>(
  (ref) => SentRequestRepository(ref.watch(appDatabaseProvider)),
);

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    db: ref.watch(appDatabaseProvider),
    settings: ref.watch(settingsStoreProvider),
  ),
);
