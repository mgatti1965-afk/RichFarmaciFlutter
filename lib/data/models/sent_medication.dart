import 'json_helpers.dart';

/// Un farmaco incluso in una richiesta inviata (copia, non collegata a Medication).
class SentMedication {
  const SentMedication({
    required this.nome,
    required this.scatole,
    this.note = '',
  });

  factory SentMedication.fromJson(Map<String, dynamic> json) => SentMedication(
        nome: readString(json, 'nome', ''),
        scatole: readInt(json, 'scatole', 1),
        note: readString(json, 'note', ''),
      );

  final String nome;
  final int scatole;
  final String note;

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'scatole': scatole,
        'note': note,
      };

  @override
  bool operator ==(Object other) =>
      other is SentMedication &&
      other.nome == nome &&
      other.scatole == scatole &&
      other.note == note;

  @override
  int get hashCode => Object.hash(nome, scatole, note);

  // --- Formato testuale del vecchio backup (campo "farmaciSerialized") ---
  // Elementi separati da "|||", campi da "###".
  // Escape: "|" -> "\bar" e "#" -> "\hash" (stesso comportamento dell'app Kotlin).

  static String serializeList(List<SentMedication> list) => list
      .map((m) => '${_escape(m.nome)}###${m.scatole}###${_escape(m.note)}')
      .join('|||');

  static List<SentMedication> deserializeList(String text) {
    if (text.trim().isEmpty) return const [];
    final result = <SentMedication>[];
    for (final part in text.split('|||')) {
      final fields = part.split('###');
      if (fields.length >= 2) {
        result.add(SentMedication(
          nome: _unescape(fields[0]),
          scatole: int.tryParse(fields[1]) ?? 1,
          note: fields.length > 2 ? _unescape(fields[2]) : '',
        ));
      }
    }
    return result;
  }

  static String _escape(String s) =>
      s.replaceAll('|', r'\bar').replaceAll('#', r'\hash');

  static String _unescape(String s) =>
      s.replaceAll(r'\bar', '|').replaceAll(r'\hash', '#');
}
