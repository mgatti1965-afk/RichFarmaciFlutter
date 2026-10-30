import '../../core/uuid.dart';
import 'italian_date.dart';
import 'json_helpers.dart';
import 'sent_medication.dart';

/// Una richiesta inviata al medico (voce dello storico).
class SentRequest {
  SentRequest({
    String? id,
    required this.profileId,
    required this.sentAt,
    required this.pazienteNome,
    required this.medicoNome,
    required this.farmaci,
    required this.testoCompleto,
  }) : id = id ?? generateUuid();

  /// Legge una richiesta da un backup.
  ///
  /// Formato nuovo (versione 2): campi `sentAt` (ISO-8601) e `farmaci` (lista).
  /// Formato vecchio (versione 1, app Kotlin): campi `data` (testo italiano)
  /// e `farmaciSerialized`.
  ///
  /// Se la data vecchia non e' leggibile si usa [fallbackDate].
  factory SentRequest.fromJson(
    Map<String, dynamic> json, {
    required DateTime fallbackDate,
  }) {
    DateTime? sentAt;
    final iso = json['sentAt'];
    if (iso is String) sentAt = DateTime.tryParse(iso)?.toLocal();
    sentAt ??= parseItalianDate(readString(json, 'data', ''));

    final List<SentMedication> farmaci;
    if (json['farmaci'] is List) {
      farmaci = readObjectList(json, 'farmaci')
          .map(SentMedication.fromJson)
          .toList();
    } else {
      farmaci = SentMedication.deserializeList(
        readString(json, 'farmaciSerialized', ''),
      );
    }

    return SentRequest(
      id: json['id'] is String ? json['id'] as String : null,
      profileId: readString(json, 'profileId', ''),
      sentAt: sentAt ?? fallbackDate,
      pazienteNome: readString(json, 'pazienteNome', ''),
      medicoNome: readString(json, 'medicoNome', ''),
      farmaci: farmaci,
      testoCompleto: readString(json, 'testoCompleto', ''),
    );
  }

  final String id;
  final String profileId;
  final DateTime sentAt;
  final String pazienteNome;
  final String medicoNome;
  final List<SentMedication> farmaci;
  final String testoCompleto;

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileId': profileId,
        'sentAt': sentAt.toUtc().toIso8601String(),
        'pazienteNome': pazienteNome,
        'medicoNome': medicoNome,
        'farmaci': farmaci.map((m) => m.toJson()).toList(),
        'testoCompleto': testoCompleto,
      };
}
