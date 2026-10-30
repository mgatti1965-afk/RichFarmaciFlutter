import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/patient_settings.dart';
import '../data/models/profile.dart';
import '../domain/sample_medications.dart';
import '../domain/settings_rules.dart';
import 'flags_providers.dart';
import 'providers.dart';
import 'reminder_sync.dart';
import 'state_providers.dart';

/// Gestione dei profili e delle impostazioni (parte del MainViewModel Kotlin).
class ProfileController {
  ProfileController(this._ref);

  final Ref _ref;

  /// All'avvio: tiene il profilo attivo salvato se esiste ancora, altrimenti
  /// sceglie il primo. Restituisce false se non c'e' nessun profilo e
  /// quindi l'utente deve prima inserire i propri dati.
  ///
  /// Differenza da Kotlin: li' si sceglieva sempre il primo profilo; qui
  /// si ricorda l'ultimo usato, utile a chi ha piu' profili.
  Future<bool> initialize() async {
    final profiles = await _ref.read(profileRepositoryProvider).getAll();
    final active = _ref.read(activeProfileIdProvider.notifier);
    if (profiles.isEmpty) {
      await active.select(null);
      return false;
    }
    final storedId = _ref.read(activeProfileIdProvider);
    final stillExists = profiles.any((p) => p.id == storedId);
    if (!stillExists) await active.select(profiles.first.id);
    return true;
  }

  Future<void> selectProfile(String id) =>
      _ref.read(activeProfileIdProvider.notifier).select(id);

  /// Prepara l'inserimento di un nuovo profilo (nessun profilo attivo).
  Future<void> startNewProfile() =>
      _ref.read(activeProfileIdProvider.notifier).select(null);

  /// Salva le impostazioni: aggiorna il profilo attivo, oppure ne crea uno
  /// nuovo se non ce n'e' uno attivo. I dati vengono puliti (spazi, codice
  /// fiscale in maiuscolo, telefono). Poi riallinea i promemoria e, se il
  /// codice fiscale e' quello speciale e il profilo non ha farmaci,
  /// aggiunge i farmaci di esempio (decisione D3).
  Future<Profile> saveSettings(PatientSettings settings) async {
    final profiles = _ref.read(profileRepositoryProvider);
    final clean = SettingsRules.sanitize(settings);

    final activeId = _ref.read(activeProfileIdProvider);
    final existing = activeId == null ? null : await profiles.getById(activeId);
    final profile = existing == null
        ? Profile.fromSettings(clean)
        : existing.withSettings(clean);

    await profiles.save(profile);
    await _ref.read(activeProfileIdProvider.notifier).select(profile.id);

    final meds = _ref.read(medicationRepositoryProvider);
    if (isSpecialCodiceFiscale(clean.pazienteCf) &&
        (await meds.getByProfile(profile.id)).isEmpty) {
      await meds.saveAll(defaultMedications(profile.id));
    }

    await _ref.read(reminderSyncProvider).syncProfile(profile.id);
    return profile;
  }

  /// Cancella un profilo con i suoi farmaci e il suo storico. Se era quello
  /// attivo passa al primo rimasto. Restituisce true se resta almeno un
  /// profilo, false se non ne resta nessuno (l'app deve chiedere i dati).
  Future<bool> deleteProfile(String id) async {
    await _ref.read(reminderSyncProvider).cancelProfile(id);
    final profiles = _ref.read(profileRepositoryProvider);
    await profiles.delete(id);

    final remaining = await profiles.getAll();
    if (_ref.read(activeProfileIdProvider) == id) {
      await _ref
          .read(activeProfileIdProvider.notifier)
          .select(remaining.isEmpty ? null : remaining.first.id);
    }
    return remaining.isNotEmpty;
  }

  /// Cancella tutti i dati e le preferenze ("azzera tutto").
  Future<void> resetEverything() async {
    await _ref.read(reminderSchedulerProvider).cancelAll();
    await _ref.read(appDatabaseProvider).deleteAllData();
    await _ref.read(settingsStoreProvider).clear();
    _ref.read(activeProfileIdProvider.notifier).reload();
    _ref.read(requestSelectionProvider.notifier).clear();
    reloadAllFlags(_ref);
  }
}

final profileControllerProvider =
    Provider<ProfileController>((ref) => ProfileController(ref));
