import 'db/app_database.dart';
import 'models/backup_data.dart';
import 'repositories/medication_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/sent_request_repository.dart';
import 'settings_store.dart';

/// Esito di un ripristino, per dirlo all'utente in parole semplici.
class RestoreResult {
  const RestoreResult({
    required this.profiles,
    required this.medications,
    required this.sentRequests,
    required this.skipped,
  });

  final int profiles;
  final int medications;
  final int sentRequests;

  /// Elementi scartati perche' collegati a un profilo che non c'e' nel file.
  final int skipped;
}

/// Crea e ripristina l'archivio (backup). Lavora solo sui dati: il file
/// vero e proprio (salva, condividi, scegli) e' gestito dall'interfaccia.
class BackupService {
  // I parametri hanno un nome pubblico (db, settings) ma i campi sono
  // privati, quindi l'assegnazione resta nell'elenco di inizializzazione.
  // ignore_for_file: prefer_initializing_formals
  BackupService({
    required AppDatabase db,
    required SettingsStore settings,
  })  : _db = db,
        _settings = settings,
        _profiles = ProfileRepository(db),
        _medications = MedicationRepository(db),
        _requests = SentRequestRepository(db);

  final AppDatabase _db;
  final SettingsStore _settings;
  final ProfileRepository _profiles;
  final MedicationRepository _medications;
  final SentRequestRepository _requests;

  /// Raccoglie tutti i dati in un archivio.
  Future<BackupData> export() async => BackupData(
        profiles: await _profiles.getAll(),
        medications: await _medications.getAll(),
        sentRequests: await _requests.getAll(),
        donationCount: _settings.donationCount,
        onboardingShown: _settings.onboardingShown,
        disclaimerAccepted: _settings.disclaimerAccepted,
      );

  /// Testo pronto da scrivere nel file di archivio.
  Future<String> exportToJson() async => (await export()).toJsonString();

  /// Legge un archivio da testo e lo ripristina. Lancia [FormatException]
  /// (con un messaggio comprensibile) se il file non e' valido. In quel caso
  /// i dati attuali NON vengono toccati.
  Future<RestoreResult> restoreFromJson(String text) async =>
      restore(BackupData.parse(text));

  /// Sostituisce tutti i dati con quelli dell'archivio, in un'unica
  /// operazione: se qualcosa fallisce, restano i dati di prima.
  Future<RestoreResult> restore(BackupData data) async {
    final profileIds = data.profiles.map((p) => p.id).toSet();
    final meds =
        data.medications.where((m) => profileIds.contains(m.profileId)).toList();
    final requests = data.sentRequests
        .where((r) => profileIds.contains(r.profileId))
        .toList();
    final skipped = (data.medications.length - meds.length) +
        (data.sentRequests.length - requests.length);

    await _db.transaction(() async {
      await _db.deleteAllData();
      for (final p in data.profiles) {
        await _profiles.save(p);
      }
      await _medications.saveAll(meds);
      for (final r in requests) {
        await _requests.save(r);
      }
    });

    // Le preferenze si scrivono solo dopo che il database e' a posto.
    await _settings.setActiveProfileId(
        data.profiles.isEmpty ? null : data.profiles.first.id);
    await _settings.setOnboardingShown(data.onboardingShown);
    await _settings.setDisclaimerAccepted(data.disclaimerAccepted);
    await _settings.clearDonationAndSet(data.donationCount);

    return RestoreResult(
      profiles: data.profiles.length,
      medications: meds.length,
      sentRequests: requests.length,
      skipped: skipped,
    );
  }
}
