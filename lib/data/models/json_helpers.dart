/// Funzioni di lettura tolleranti per il JSON: un campo mancante o nullo
/// restituisce il valore predefinito, come i valori di default di Moshi/Kotlin.
String readString(Map<String, dynamic> json, String key, String fallback) {
  final value = json[key];
  return value is String ? value : fallback;
}

int readInt(Map<String, dynamic> json, String key, int fallback) {
  final value = json[key];
  return value is num ? value.toInt() : fallback;
}

bool readBool(Map<String, dynamic> json, String key, bool fallback) {
  final value = json[key];
  return value is bool ? value : fallback;
}

/// Legge una lista di oggetti JSON ignorando gli elementi non validi.
List<Map<String, dynamic>> readObjectList(
  Map<String, dynamic> json,
  String key,
) {
  final value = json[key];
  if (value is! List) return const [];
  return value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
}
