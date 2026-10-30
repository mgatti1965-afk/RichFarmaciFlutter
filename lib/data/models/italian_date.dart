/// Legge le date testuali scritte dall'app Kotlin nel campo `data` delle
/// richieste inviate, es. "15 giu 2026, Ore 15:30" (formato
/// "dd MMM yyyy, 'Ore' HH:mm" con lingua italiana).
///
/// Accetta anche il mese per esteso ("15 Giugno 2026 - 15:30") e un
/// eventuale punto dopo l'abbreviazione. Restituisce null se il testo
/// non e' riconosciuto.
DateTime? parseItalianDate(String text) {
  final match = RegExp(
    r'(\d{1,2})\s+([A-Za-zÀ-ÿ]+)\.?\s+(\d{4})\D+(\d{1,2}):(\d{2})',
  ).firstMatch(text);
  if (match == null) return null;

  final month = _months[match.group(2)!.toLowerCase().substring(0, 3)];
  if (month == null) return null;

  final day = int.parse(match.group(1)!);
  final year = int.parse(match.group(3)!);
  final hour = int.parse(match.group(4)!);
  final minute = int.parse(match.group(5)!);
  if (day < 1 || day > 31 || hour > 23 || minute > 59) return null;

  return DateTime(year, month, day, hour, minute);
}

const Map<String, int> _months = {
  'gen': 1,
  'feb': 2,
  'mar': 3,
  'apr': 4,
  'mag': 5,
  'giu': 6,
  'lug': 7,
  'ago': 8,
  'set': 9,
  'ott': 10,
  'nov': 11,
  'dic': 12,
};
