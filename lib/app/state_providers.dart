import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/medication.dart';
import '../data/models/profile.dart';
import '../data/models/sent_request.dart';
import '../domain/request_selection.dart';
import '../domain/settings_rules.dart';
import 'providers.dart';

/// Id del profilo attivo (salvato nelle preferenze).
class ActiveProfileIdNotifier extends Notifier<String?> {
  @override
  String? build() => ref.watch(settingsStoreProvider).activeProfileId;

  Future<void> select(String? id) async {
    await ref.read(settingsStoreProvider).setActiveProfileId(id);
    state = id;
  }

  /// Rilegge l'id dalle preferenze (dopo un ripristino o un azzeramento).
  void reload() => state = ref.read(settingsStoreProvider).activeProfileId;
}

final activeProfileIdProvider =
    NotifierProvider<ActiveProfileIdNotifier, String?>(
  ActiveProfileIdNotifier.new,
);

/// Tutti i profili, aggiornati in tempo reale.
final profilesProvider = StreamProvider<List<Profile>>(
  (ref) => ref.watch(profileRepositoryProvider).watchAll(),
);

/// Il profilo attivo, oppure null se non ce n'e' uno valido.
final activeProfileProvider = Provider<Profile?>((ref) {
  final id = ref.watch(activeProfileIdProvider);
  final profiles = ref.watch(profilesProvider).value;
  if (id == null || profiles == null) return null;
  for (final p in profiles) {
    if (p.id == id) return p;
  }
  return null;
});

/// Farmaci del profilo attivo, in ordine alfabetico.
final medicationsProvider = StreamProvider<List<Medication>>((ref) {
  final id = ref.watch(activeProfileIdProvider);
  if (id == null) return Stream.value(const <Medication>[]);
  return ref.watch(medicationRepositoryProvider).watchByProfile(id);
});

/// Storico del profilo attivo, dal piu' recente.
final historyProvider = StreamProvider<List<SentRequest>>((ref) {
  final id = ref.watch(activeProfileIdProvider);
  if (id == null) return Stream.value(const <SentRequest>[]);
  return ref.watch(sentRequestRepositoryProvider).watchByProfile(id);
});

/// Vero se c'e' un profilo attivo (come isConfigured di Kotlin).
final isConfiguredProvider = Provider<bool>(
  (ref) => ref.watch(activeProfileProvider) != null,
);

/// Vero se il profilo attivo ha tutti i dati per inviare una richiesta.
final canSendProvider = Provider<bool>((ref) {
  final profile = ref.watch(activeProfileProvider);
  return profile != null && SettingsRules.isComplete(profile.toSettings());
});

/// Scelta dei farmaci nel modulo di richiesta. Si svuota da sola
/// quando cambia il profilo attivo.
class RequestSelectionNotifier extends Notifier<RequestSelection> {
  @override
  RequestSelection build() {
    ref.listen<String?>(activeProfileIdProvider, (previous, next) {
      state = RequestSelection.empty;
    });
    return RequestSelection.empty;
  }

  void toggle(Medication med) => state = state.toggle(med);

  void setQuantity(String medicationId, int quantity) =>
      state = state.setQuantity(medicationId, quantity);

  void setNote(String medicationId, String note) =>
      state = state.setNote(medicationId, note);

  void update(Medication med, int quantity) =>
      state = state.update(med, quantity);

  void deselect(Medication med) => state = state.deselect(med);

  void clear() => state = RequestSelection.empty;
}

final requestSelectionProvider =
    NotifierProvider<RequestSelectionNotifier, RequestSelection>(
  RequestSelectionNotifier.new,
);
