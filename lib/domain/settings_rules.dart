import '../data/models/enums.dart';
import '../data/models/patient_settings.dart';

/// Regole sui dati del profilo (da PatientSettingsManager di Kotlin).
class SettingsRules {
  const SettingsRules._();

  /// Telefono: via gli spazi, poi via tutto cio' che non e' "+" o cifra.
  static String cleanPhone(String phone) => phone
      .replaceAll(RegExp(r'\s'), '')
      .replaceAll(RegExp(r'[^+0-9]'), '');

  /// Verifica se la sintassi del numero di telefono è valida.
  /// Accetta solo cifre, spazi, trattini, punti e facoltativamente un '+' iniziale.
  /// Deve contenere tra 7 e 15 cifre.
  static bool isValidPhone(String phone) {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return false;
    if (!RegExp(r'^\+?[0-9\s\-.]+$').hasMatch(trimmed)) {
      return false;
    }
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 7 && digits.length <= 15;
  }

  /// Verifica se la sintassi dell'indirizzo email è valida.
  static bool isValidEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
    );
    return emailRegex.hasMatch(trimmed);
  }

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
