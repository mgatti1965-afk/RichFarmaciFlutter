import '../data/models/medication.dart';

/// Stato del modulo "richiesta": quali farmaci sono scelti, con quale
/// quantita' e con quale nota temporanea. E' immutabile: ogni operazione
/// restituisce un nuovo oggetto. Equivale a selectedMedicationIds,
/// selectedQuantities e selectedNotes del MainViewModel Kotlin.
class RequestSelection {
  const RequestSelection({
    this.selectedIds = const <String>{},
    this.quantities = const <String, int>{},
    this.notes = const <String, String>{},
  });

  static const RequestSelection empty = RequestSelection();

  final Set<String> selectedIds;

  /// Quantita' scelta per id farmaco (diversa da quella standard).
  final Map<String, int> quantities;

  /// Note temporanee per id farmaco (diverse dalla nota fissa del farmaco).
  final Map<String, String> notes;

  bool get isEmpty => selectedIds.isEmpty;

  /// Numero di farmaci selezionati per la richiesta.
  int get count => selectedIds.length;

  bool isSelected(String medicationId) => selectedIds.contains(medicationId);

  /// Quantita' scelta per id farmaco (se non impostata restituisce 1).
  int quantity(String medicationId) => quantities[medicationId] ?? 1;

  /// Quantita' da usare: quella scelta, altrimenti quella standard.
  int quantityFor(Medication med) => quantities[med.id] ?? med.scatole;

  String noteFor(Medication med) => notes[med.id] ?? '';

  /// Seleziona o deseleziona. Selezionando, precompila la quantita' standard
  /// (minimo 1) e una nota vuota; deselezionando, cancella quantita' e nota.
  RequestSelection toggle(Medication med) {
    if (selectedIds.contains(med.id)) {
      return RequestSelection(
        selectedIds: {...selectedIds}..remove(med.id),
        quantities: {...quantities}..remove(med.id),
        notes: {...notes}..remove(med.id),
      );
    }
    return RequestSelection(
      selectedIds: {...selectedIds, med.id},
      quantities: {...quantities, med.id: _atLeastOne(med.scatole)},
      notes: {...notes, med.id: ''},
    );
  }

  /// Imposta la quantita' (minimo 1).
  RequestSelection setQuantity(String medicationId, int quantity) =>
      RequestSelection(
        selectedIds: selectedIds,
        quantities: {...quantities, medicationId: _atLeastOne(quantity)},
        notes: notes,
      );

  RequestSelection setNote(String medicationId, String note) =>
      RequestSelection(
        selectedIds: selectedIds,
        quantities: quantities,
        notes: {...notes, medicationId: note},
      );

  /// Come updateSelection di Kotlin: quantita' 0 o meno deseleziona;
  /// altrimenti seleziona (se serve) e imposta la quantita'.
  RequestSelection update(Medication med, int quantity) {
    if (quantity <= 0) {
      return isSelected(med.id) ? toggle(med) : this;
    }
    final selected = isSelected(med.id) ? this : toggle(med);
    return selected.setQuantity(med.id, quantity);
  }

  /// Toglie il farmaco dalla selezione se c'e' (es. quando va "in pausa").
  RequestSelection deselect(Medication med) =>
      isSelected(med.id) ? toggle(med) : this;

  static int _atLeastOne(int value) => value < 1 ? 1 : value;
}
