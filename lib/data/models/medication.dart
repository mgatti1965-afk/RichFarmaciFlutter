import '../../core/uuid.dart';
import 'defaults.dart';
import 'enums.dart';
import 'json_helpers.dart';

/// Un farmaco appartenente a un profilo.
class Medication {
  Medication({
    String? id,
    required this.profileId,
    required this.nome,
    this.scatole = 1,
    this.note = '',
    this.inPausa = false,
    this.notificaAttiva = false,
    this.orarioNotifica = defaultOrarioNotifica,
    this.frequenzaValore = 1,
    this.frequenzaTipo = FrequencyUnit.giorni,
  }) : id = id ?? generateUuid();

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] is String ? json['id'] as String : null,
      profileId: readString(json, 'profileId', ''),
      nome: readString(json, 'nome', ''),
      scatole: readInt(json, 'scatole', 1),
      note: readString(json, 'note', ''),
      inPausa: readBool(json, 'inPausa', false),
      notificaAttiva: readBool(json, 'notificaAttiva', false),
      orarioNotifica: readString(json, 'orarioNotifica', defaultOrarioNotifica),
      frequenzaValore: readInt(json, 'frequenzaValore', 1),
      frequenzaTipo: FrequencyUnit.fromCode(
        readString(json, 'frequenzaTipo', 'GIORNI'),
      ),
    );
  }

  final String id;
  final String profileId;
  final String nome;
  final int scatole;
  final String note;
  final bool inPausa;
  final bool notificaAttiva;

  /// Uno o piu' orari "HH:mm" separati da virgola, es. "08:00,20:00".
  final String orarioNotifica;

  /// 0 = nessuna ripetizione.
  final int frequenzaValore;
  final FrequencyUnit frequenzaTipo;

  /// Gli orari come lista, senza voci vuote.
  List<String> get orari => orarioNotifica
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  Medication copyWith({
    String? profileId,
    String? nome,
    int? scatole,
    String? note,
    bool? inPausa,
    bool? notificaAttiva,
    String? orarioNotifica,
    int? frequenzaValore,
    FrequencyUnit? frequenzaTipo,
  }) {
    return Medication(
      id: id,
      profileId: profileId ?? this.profileId,
      nome: nome ?? this.nome,
      scatole: scatole ?? this.scatole,
      note: note ?? this.note,
      inPausa: inPausa ?? this.inPausa,
      notificaAttiva: notificaAttiva ?? this.notificaAttiva,
      orarioNotifica: orarioNotifica ?? this.orarioNotifica,
      frequenzaValore: frequenzaValore ?? this.frequenzaValore,
      frequenzaTipo: frequenzaTipo ?? this.frequenzaTipo,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileId': profileId,
        'nome': nome,
        'scatole': scatole,
        'note': note,
        'inPausa': inPausa,
        'notificaAttiva': notificaAttiva,
        'orarioNotifica': orarioNotifica,
        'frequenzaValore': frequenzaValore,
        'frequenzaTipo': frequenzaTipo.code,
      };

  @override
  bool operator ==(Object other) =>
      other is Medication &&
      other.id == id &&
      other.profileId == profileId &&
      other.nome == nome &&
      other.scatole == scatole &&
      other.note == note &&
      other.inPausa == inPausa &&
      other.notificaAttiva == notificaAttiva &&
      other.orarioNotifica == orarioNotifica &&
      other.frequenzaValore == frequenzaValore &&
      other.frequenzaTipo == frequenzaTipo;

  @override
  int get hashCode => Object.hash(id, profileId, nome, scatole, note, inPausa,
      notificaAttiva, orarioNotifica, frequenzaValore, frequenzaTipo);
}
