import '../../core/uuid.dart';
import 'defaults.dart';
import 'enums.dart';
import 'json_helpers.dart';
import 'patient_settings.dart';

/// Profilo di un paziente (con i dati del medico e le preferenze di invio).
class Profile {
  Profile({
    String? id,
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
  }) : id = id ?? generateUuid();

  /// Legge un profilo dal JSON di backup (stessi nomi di campo dell'app Kotlin).
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] is String ? json['id'] as String : null,
      pazienteNome: readString(json, 'pazienteNome', ''),
      pazienteCf: readString(json, 'pazienteCf', ''),
      medicoNome: readString(json, 'medicoNome', ''),
      medicoTelefono: readString(json, 'medicoTelefono', ''),
      medicoEmail: readString(json, 'medicoEmail', ''),
      secondoIndirizzo: readString(json, 'secondoIndirizzo', ''),
      messaggioTesta: readString(json, 'messaggioTesta', defaultMessaggioTesta),
      messaggioCoda: readString(json, 'messaggioCoda', defaultMessaggioCoda),
      tipoInvio: SendChannel.fromCode(readInt(json, 'tipoInvio', 0)),
      notificheAttive: readBool(json, 'notificheAttive', false),
      descrizioneNotifica: readString(
        json,
        'descrizioneNotifica',
        defaultDescrizioneNotifica,
      ),
    );
  }

  final String id;
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'pazienteNome': pazienteNome,
        'pazienteCf': pazienteCf,
        'medicoNome': medicoNome,
        'medicoTelefono': medicoTelefono,
        'medicoEmail': medicoEmail,
        'secondoIndirizzo': secondoIndirizzo,
        'messaggioTesta': messaggioTesta,
        'messaggioCoda': messaggioCoda,
        'tipoInvio': tipoInvio.code,
        'notificheAttive': notificheAttive,
        'descrizioneNotifica': descrizioneNotifica,
      };

  /// Vista come impostazioni (equivale a updateConfigStatus del ViewModel).
  PatientSettings toSettings() => PatientSettings(
        pazienteNome: pazienteNome,
        pazienteCf: pazienteCf,
        medicoNome: medicoNome,
        medicoTelefono: medicoTelefono,
        medicoEmail: medicoEmail,
        secondoIndirizzo: secondoIndirizzo,
        messaggioTesta: messaggioTesta,
        messaggioCoda: messaggioCoda,
        tipoInvio: tipoInvio,
        notificheAttive: notificheAttive,
        descrizioneNotifica: descrizioneNotifica,
      );

  /// Copia del profilo con le impostazioni nuove (stesso id).
  Profile withSettings(PatientSettings settings) => Profile(
        id: id,
        pazienteNome: settings.pazienteNome,
        pazienteCf: settings.pazienteCf,
        medicoNome: settings.medicoNome,
        medicoTelefono: settings.medicoTelefono,
        medicoEmail: settings.medicoEmail,
        secondoIndirizzo: settings.secondoIndirizzo,
        messaggioTesta: settings.messaggioTesta,
        messaggioCoda: settings.messaggioCoda,
        tipoInvio: settings.tipoInvio,
        notificheAttive: settings.notificheAttive,
        descrizioneNotifica: settings.descrizioneNotifica,
      );

  /// Nuovo profilo (con nuovo id) creato a partire dalle impostazioni.
  factory Profile.fromSettings(PatientSettings settings) =>
      Profile().withSettings(settings);

  @override
  bool operator ==(Object other) =>
      other is Profile && other.id == id && other.toSettings() == toSettings();

  @override
  int get hashCode => Object.hash(id, toSettings());
}
