import '../data/models/medication.dart';
import '../data/models/patient_settings.dart';
import '../data/models/sent_medication.dart';
import '../data/models/sent_request.dart';
import 'request_selection.dart';

bool _isBlank(String s) => s.trim().isEmpty;

/// Farmaci scelti, nell'ordine della lista ricevuta.
List<Medication> _selected(List<Medication> meds, RequestSelection sel) =>
    meds.where((m) => sel.isSelected(m.id)).toList();

/// Testo della richiesta al medico (stesso formato di buildFormattedMessage).
///
/// Sezioni separate da una riga vuota: frase di testa, elenco farmaci
/// (separati da una riga vuota), dati del paziente, frase di coda.
String buildRequestMessage({
  required PatientSettings settings,
  required List<Medication> medications,
  required RequestSelection selection,
}) {
  final sections = <String>[];

  if (!_isBlank(settings.messaggioTesta)) {
    sections.add(settings.messaggioTesta.trim());
  }

  final lines = _selected(medications, selection).map((med) {
    final qty = selection.quantityFor(med);
    final temp = selection.noteFor(med);
    final base = med.note;
    final String noteText;
    if (!_isBlank(temp) && !_isBlank(base)) {
      noteText = ' ($base - $temp)';
    } else if (!_isBlank(temp)) {
      noteText = ' ($temp)';
    } else if (!_isBlank(base)) {
      noteText = ' ($base)';
    } else {
      noteText = '';
    }
    final word = qty == 1 ? 'scatola' : 'scatole';
    return '- ${med.nome}: $qty $word$noteText';
  }).toList();
  if (lines.isNotEmpty) sections.add(lines.join('\n\n'));

  sections.add([
    'Nome Paziente: ${settings.pazienteNome}',
    'Codice Fiscale: ${settings.pazienteCf.toUpperCase()}',
  ].join('\n'));

  if (!_isBlank(settings.messaggioCoda)) {
    sections.add(settings.messaggioCoda.trim());
  }

  return sections.join('\n\n');
}

/// Messaggio libero con i dati del paziente per farsi riconoscere.
String buildQuickMessage(PatientSettings settings, String customText) =>
    'Messaggio da ${settings.pazienteNome} (CF: ${settings.pazienteCf}):'
    '\n\n$customText';

/// Farmaci da salvare nello storico. La nota unisce quella fissa e quella
/// temporanea con " - " (come recordSentRequest di Kotlin).
List<SentMedication> buildSentMedications(
  List<Medication> medications,
  RequestSelection selection,
) {
  return _selected(medications, selection).map((med) {
    final temp = selection.noteFor(med);
    final base = med.note;
    final String note;
    if (!_isBlank(temp) && !_isBlank(base)) {
      note = '$base - $temp';
    } else if (!_isBlank(temp)) {
      note = temp;
    } else {
      note = base;
    }
    return SentMedication(
      nome: med.nome,
      scatole: selection.quantityFor(med),
      note: note,
    );
  }).toList();
}

/// Voce di storico da salvare dopo l'invio.
SentRequest buildSentRequest({
  required String profileId,
  required PatientSettings settings,
  required List<Medication> medications,
  required RequestSelection selection,
  required String messageText,
  required DateTime now,
}) {
  return SentRequest(
    profileId: profileId,
    sentAt: now,
    pazienteNome: settings.pazienteNome,
    medicoNome: settings.medicoNome,
    farmaci: buildSentMedications(medications, selection),
    testoCompleto: messageText,
  );
}
