import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/enums.dart';
import '../data/models/medication.dart';
import 'providers.dart';
import 'reminder_sync.dart';
import 'state_providers.dart';

/// Aggiunta, modifica, pausa ed eliminazione dei farmaci del profilo attivo.
class MedicationController {
  MedicationController(this._ref);

  final Ref _ref;

  /// Aggiunge un farmaco al profilo attivo. Restituisce null se non c'e'
  /// un profilo attivo o il nome e' vuoto. Le quantita' negative diventano 0.
  /// I valori predefiniti di frequenza (nessuna ripetizione, in ore) sono
  /// quelli di addMedication in Kotlin.
  Future<Medication?> add({
    required String nome,
    int scatole = 1,
    String note = '',
    bool notificaAttiva = false,
    String orarioNotifica = '08:00',
    int frequenzaValore = 0,
    FrequencyUnit frequenzaTipo = FrequencyUnit.ore,
  }) async {
    final profileId = _ref.read(activeProfileIdProvider);
    if (profileId == null || nome.trim().isEmpty) return null;

    final med = Medication(
      profileId: profileId,
      nome: nome.trim(),
      scatole: scatole < 0 ? 0 : scatole,
      note: note.trim(),
      notificaAttiva: notificaAttiva,
      orarioNotifica: orarioNotifica,
      frequenzaValore: frequenzaValore,
      frequenzaTipo: frequenzaTipo,
    );
    await _ref.read(medicationRepositoryProvider).save(med);
    await _sync(med);
    return med;
  }

  /// Mette il farmaco in pausa o lo riattiva. In pausa viene tolto dalla
  /// richiesta in corso e il promemoria viene annullato.
  Future<Medication> toggleStandby(Medication med) async {
    final updated = med.copyWith(inPausa: !med.inPausa);
    await _ref.read(medicationRepositoryProvider).save(updated);
    if (updated.inPausa) {
      _ref.read(requestSelectionProvider.notifier).deselect(updated);
    }
    await _sync(updated);
    return updated;
  }

  Future<void> update(Medication med) async {
    await _ref.read(medicationRepositoryProvider).save(med);
    await _sync(med);
  }

  Future<void> delete(Medication med) async {
    await _ref.read(reminderSchedulerProvider).cancel(med);
    await _ref.read(medicationRepositoryProvider).delete(med.id);
    _ref.read(requestSelectionProvider.notifier).deselect(med);
  }

  Future<void> _sync(Medication med) async {
    final profile =
        await _ref.read(profileRepositoryProvider).getById(med.profileId);
    if (profile == null) return;
    await _ref.read(reminderSyncProvider).syncMedication(med, profile);
  }
}

final medicationControllerProvider =
    Provider<MedicationController>((ref) => MedicationController(ref));
