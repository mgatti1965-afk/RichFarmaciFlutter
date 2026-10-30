import '../data/models/enums.dart';
import '../data/models/patient_settings.dart';

/// Regole sui dati del profilo (da PatientSettingsManager di Kotlin).
class SettingsRules {
  const SettingsRules._();

  /// Telefono: via gli spazi, poi via tutto cio' che non e' "+" o cifra.
  static String cleanPhone(String phone) => phone
      .replaceAll(RegExp(r'\s'), '')
      .replaceAll(RegExp(r'[^+0-9]'), '');

  /// Dati pronti da salvare: testi senza spazi ai bordi, codice fiscale
  /// in maiuscolo, telefono pulito.
  static PatientSettings sanitize(PatientSettings s) => PatientSettings(
        pazienteNome: s.pazienteNome.trim(),
        pazienteCf: s.pazienteCf.trim().toUpperCase(),
        medicoNome: s.medicoNome.trim(),
        medicoTelefono: cleanPhone(s.medicoTelefono),
        medicoEmail: s.medicoEmail.trim(),
        secondoIndirizzo: s.secondoIndirizzo.trim(),
        messaggioTesta: s.messaggioTesta.trim(),
        messaggioCoda: s.messaggioCoda.trim(),
        tipoInvio: s.tipoInvio,
        notificheAttive: s.notificheAttive,
        descrizioneNotifica: s.descrizioneNotifica.trim(),
      );

  /// Impostazioni complete: nome paziente, codice fiscale, nome medico e
  /// un recapito (email se il canale e' email, altrimenti telefono).
  static bool isComplete(PatientSettings s) {
    final hasContact = s.tipoInvio == SendChannel.email
        ? s.medicoEmail.trim().isNotEmpty
        : s.medicoTelefono.trim().isNotEmpty;
    return s.pazienteNome.trim().isNotEmpty &&
        s.pazienteCf.trim().isNotEmpty &&
        s.medicoNome.trim().isNotEmpty &&
        hasContact;
  }

  /// Elenco dei campi mancanti, in parole semplici (per i messaggi
  /// agli utenti). Vuoto se i dati sono completi.
  static List<String> missingFields(PatientSettings s) {
    final missing = <String>[];
    if (s.pazienteNome.trim().isEmpty) missing.add('Il nome del paziente');
    if (s.pazienteCf.trim().isEmpty) missing.add('Il codice fiscale');
    if (s.medicoNome.trim().isEmpty) missing.add('Il nome del medico');
    if (s.tipoInvio == SendChannel.email) {
      if (s.medicoEmail.trim().isEmpty) missing.add("L'email del medico");
    } else if (s.medicoTelefono.trim().isEmpty) {
      missing.add('Il telefono del medico');
    }
    return missing;
  }
}
