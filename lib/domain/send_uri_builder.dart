import '../data/models/enums.dart';
import '../data/models/patient_settings.dart';

/// Costruisce il link che apre WhatsApp, SMS o email gia' compilati.
/// Restituisce testo (da passare a Uri.parse) cosi' la codifica resta
/// esattamente quella scritta qui. La codifica di Uri.encodeComponent usa
/// gli stessi caratteri sicuri di Uri.encode di Android (spazio = %20).
class SendUriBuilder {
  const SendUriBuilder._();

  /// WhatsApp: numero senza "+" e senza spazi, come nell'app Kotlin.
  static String whatsapp(String phone, String message) {
    final clean = phone.replaceAll('+', '').replaceAll(' ', '');
    return 'https://api.whatsapp.com/send?phone=$clean'
        '&text=${Uri.encodeComponent(message)}';
  }

  /// SMS. Con [ios] true il testo e' preceduto da "&" invece di "?":
  /// e' la forma usata di solito su iOS. Non e' stato provato su un
  /// iPhone reale e va verificato.
  static String sms(String phone, String message, {bool ios = false}) {
    final separator = ios ? '&' : '?';
    return 'sms:$phone${separator}body=${Uri.encodeComponent(message)}';
  }

  /// Email con oggetto "Comunicazione da: " seguito dal nome del paziente.
  static String email(String address, String patientName, String message) {
    final subject = 'Comunicazione da: $patientName';
    return 'mailto:$address?subject=${Uri.encodeComponent(subject)}'
        '&body=${Uri.encodeComponent(message)}';
  }

  /// Sceglie il canale in base alle impostazioni del profilo.
  static String forSettings(
    PatientSettings settings,
    String message, {
    bool ios = false,
  }) {
    switch (settings.tipoInvio) {
      case SendChannel.whatsapp:
        return whatsapp(settings.medicoTelefono, message);
      case SendChannel.sms:
        return sms(settings.medicoTelefono, message, ios: ios);
      case SendChannel.email:
        return email(settings.medicoEmail, settings.pazienteNome, message);
    }
  }
}
