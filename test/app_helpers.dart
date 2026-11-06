import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:richfarmaci/app/providers.dart';
import 'package:richfarmaci/app/state_providers.dart';
import 'package:richfarmaci/data/db/app_database.dart';
import 'package:richfarmaci/data/models/medication.dart';
import 'package:richfarmaci/data/models/patient_settings.dart';
import 'package:richfarmaci/data/settings_store.dart';
import 'package:richfarmaci/services/archive_file_service.dart';
import 'package:richfarmaci/services/link_opener.dart';
import 'package:richfarmaci/services/reminder_scheduler.dart';
import 'package:richfarmaci/services/telemetry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Telemetria finta: registra gli eventi tracciati.
class FakeTelemetry implements AppTelemetry {
  final List<Map<String, dynamic>> tracked = [];

  @override
  void track(String event, {Map<String, Object?> params = const {}}) {
    tracked.add({'event': event, 'params': params});
  }

  bool has(String event) => tracked.any((e) => e['event'] == event);
  int count(String event) => tracked.where((e) => e['event'] == event).length;
}

/// Gestore promemoria finto: registra le richieste invece di programmarle.
class FakeReminderScheduler implements ReminderScheduler {
  final List<String> scheduled = [];
  final List<String> cancelled = [];
  int cancelAllCount = 0;

  @override
  Future<void> schedule(Medication med, String description) async =>
      scheduled.add(med.id);

  @override
  Future<void> cancel(Medication med) async => cancelled.add(med.id);

  @override
  Future<void> cancelAll() async => cancelAllCount++;

  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<void> showTestNotification() async {}
}

/// Apertura link finta: registra i link e risponde come le si dice.
class FakeLinkOpener implements LinkOpener {
  FakeLinkOpener({this.succeeds = true});

  bool succeeds;
  final List<String> opened = [];

  @override
  Future<bool> open(String url) async {
    opened.add(url);
    return succeeds;
  }
}

/// Servizio file finto: tiene in memoria l'ultimo file condiviso e
/// restituisce il testo che gli si imposta per l'importazione.
class FakeArchiveFileService implements ArchiveFileService {
  String? sharedName;
  String? sharedJson;
  String? textToPick;
  bool throwOnShare = false;
  bool throwOnPick = false;

  @override
  Future<ArchiveShareOutcome> share({
    required String fileName,
    required String json,
  }) async {
    if (throwOnShare) throw Exception('Share error');
    sharedName = fileName;
    sharedJson = json;
    return ArchiveShareOutcome.completed;
  }

  @override
  Future<String?> pickText() async {
    if (throwOnPick) throw Exception('Pick error');
    return textToPick;
  }
}

/// Ora fissa usata nei test.
final DateTime testNow = DateTime(2026, 6, 15, 15, 30);

/// Ambiente di prova: database in memoria, preferenze finte, ora fissa.
class TestEnv {
  TestEnv._(this.db, this.settings, this.scheduler, this.links, this.files,
      this.telemetry, this.container);

  final AppDatabase db;
  final SettingsStore settings;
  final FakeReminderScheduler scheduler;
  final FakeLinkOpener links;
  final FakeArchiveFileService files;
  final FakeTelemetry telemetry;
  final ProviderContainer container;

  static Future<TestEnv> create({List<dynamic> extraOverrides = const []}) async {
    SharedPreferences.setMockInitialValues({});
    final db = AppDatabase(NativeDatabase.memory());
    final settings = await SettingsStore.open();
    final scheduler = FakeReminderScheduler();
    final links = FakeLinkOpener();
    final files = FakeArchiveFileService();
    final telemetry = FakeTelemetry();
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      settingsStoreProvider.overrideWithValue(settings),
      clockProvider.overrideWithValue(() => testNow),
      reminderSchedulerProvider.overrideWithValue(scheduler),
      linkOpenerProvider.overrideWithValue(links),
      archiveFileServiceProvider.overrideWithValue(files),
      telemetryProvider.overrideWithValue(telemetry),
      ...extraOverrides.cast(),
    ]);
    // Tiene "ascoltati" i flussi di dati durante il test. Con Riverpod 3
    // un provider letto soltanto con read() e' senza ascoltatori e viene
    // messo in pausa: il suo valore resta vuoto. Nell'app lo ascolta la
    // schermata con ref.watch, quindi li' non succede.
    container.listen(profilesProvider, (previous, next) {});
    container.listen(medicationsProvider, (previous, next) {});
    container.listen(historyProvider, (previous, next) {});
    container.listen(activeProfileProvider, (previous, next) {});
    container.listen(isConfiguredProvider, (previous, next) {});
    container.listen(canSendProvider, (previous, next) {});
    return TestEnv._(db, settings, scheduler, links, files, telemetry, container);
  }

  /// Lascia il tempo ai flussi del database di aggiornarsi.
  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 40));

  Future<void> dispose() async {
    container.dispose();
    await db.close();
  }
}

/// Impostazioni complete e valide per i test.
PatientSettings validSettings({
  String cf = 'rssmra40a01h501z',
  bool notifiche = false,
}) =>
    PatientSettings(
      pazienteNome: ' Mario ',
      pazienteCf: cf,
      medicoNome: 'Dott. Bianchi',
      medicoTelefono: '+39 333 1',
      notificheAttive: notifiche,
    );
