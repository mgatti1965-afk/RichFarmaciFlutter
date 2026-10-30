import 'defaults.dart';
import 'enums.dart';

/// Impostazioni del profilo attivo (vista dei campi di [Profile] senza id).
class PatientSettings {
  const PatientSettings({
    this.pazienteNome = '',
    this.pazienteCf = '',
    this.medicoNome = '',
    this.medicoTelefono = '',
    this.medicoEmail = '',
    this.secondoIndirizzo = '',
    this.messaggioTesta = defaultMessaggioTesta,
    this.messaggioCoda = defaultMessaggioCoda,
    this.tipoInvio = SendChannel.whatsapp,
    this.notificheAttive = false,
    this.descrizioneNotifica = defaultDescrizioneNotifica,
  });

  final String pazienteNome;
  final String pazienteCf;
  final String medicoNome;
  final String medicoTelefono;
  final String medicoEmail;
  final String secondoIndirizzo;
  final String messaggioTesta;
  final String messaggioCoda;
  final SendChannel tipoInvio;
  final bool notificheAttive;
  final String descrizioneNotifica;

  PatientSettings copyWith({
    String? pazienteNome,
    String? pazienteCf,
    String? medicoNome,
    String? medicoTelefono,
    String? medicoEmail,
    String? secondoIndirizzo,
    String? messaggioTesta,
    String? messaggioCoda,
    SendChannel? tipoInvio,
    bool? notificheAttive,
    String? descrizioneNotifica,
  }) {
    return PatientSettings(
      pazienteNome: pazienteNome ?? this.pazienteNome,
      pazienteCf: pazienteCf ?? this.pazienteCf,
      medicoNome: medicoNome ?? this.medicoNome,
      medicoTelefono: medicoTelefono ?? this.medicoTelefono,
      medicoEmail: medicoEmail ?? this.medicoEmail,
      secondoIndirizzo: secondoIndirizzo ?? this.secondoIndirizzo,
      messaggioTesta: messaggioTesta ?? this.messaggioTesta,
      messaggioCoda: messaggioCoda ?? this.messaggioCoda,
      tipoInvio: tipoInvio ?? this.tipoInvio,
      notificheAttive: notificheAttive ?? this.notificheAttive,
      descrizioneNotifica: descrizioneNotifica ?? this.descrizioneNotifica,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PatientSettings &&
      other.pazienteNome == pazienteNome &&
      other.pazienteCf == pazienteCf &&
      other.medicoNome == medicoNome &&
      other.medicoTelefono == medicoTelefono &&
      other.medicoEmail == medicoEmail &&
      other.secondoIndirizzo == secondoIndirizzo &&
      other.messaggioTesta == messaggioTesta &&
      other.messaggioCoda == messaggioCoda &&
      other.tipoInvio == tipoInvio &&
      other.notificheAttive == notificheAttive &&
      other.descrizioneNotifica == descrizioneNotifica;

  @override
  int get hashCode => Object.hash(
        pazienteNome,
        pazienteCf,
        medicoNome,
        medicoTelefono,
        medicoEmail,
        secondoIndirizzo,
        messaggioTesta,
        messaggioCoda,
        tipoInvio,
        notificheAttive,
        descrizioneNotifica,
      );
}
