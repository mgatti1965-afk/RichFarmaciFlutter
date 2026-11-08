import '../data/models/enums.dart';
import '../data/models/patient_settings.dart';

/// Costruisce il link che apre WhatsApp, SMS o email gia' compilati.
/// Restituisce testo (da passare a Uri.parse) cosi' la codifica resta
/// esattamente quella scritta qui. La codifica di Uri.encodeComponent usa
/// gli stessi caratteri sicuri di Uri.encode di Android (spazio = %20).
class SendUriBuilder {
  const SendUriBuilder._();

  /// Formatta il numero per WhatsApp, garantendo il prefisso 39 per i numeri
  /// cellulari italiani se mancante.
  static String formatWhatsappPhone(String phone) {
    var clean = phone
        .replaceAll('+', '')
        .replaceAll(' ', '')
        .replaceAll(RegExp(r'[^\d]'), '');
    if (clean.startsWith('0039')) {
      clean = clean.substring(2);
    } else if (!clean.startsWith('39') &&
        clean.startsWith('3') &&
        (clean.length == 9 || clean.length == 10)) {
      clean = '39$clean';
    }
    return clean;
  }

  /// WhatsApp: su iOS usa whatsapp://send per aprire direttamente l'app WhatsApp
  /// senza passare per il browser; su desktop usa https://api.whatsapp.com/send.
  static String whatsapp(String phone, String message, {bool ios = false}) {
    final clean = formatWhatsappPhone(phone);
    final encoded = Uri.encodeComponent(message);
    if (ios) {
      return 'whatsapp://send?phone=$clean&text=$encoded';
    }
    return 'https://api.whatsapp.com/send?phone=$clean&text=$encoded';
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
        return whatsapp(settings.medicoTelefono, message, ios: ios);
      case SendChannel.sms:
        return sms(settings.medicoTelefono, message, ios: ios);
      case SendChannel.email:
        return email(settings.medicoEmail, settings.pazienteNome, message);
    }
  }
}
