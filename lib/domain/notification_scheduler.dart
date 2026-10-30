import '../data/models/enums.dart';
import '../data/models/medication.dart';

/// Calcolo degli orari dei promemoria (da NotificationHelper di Kotlin).
/// Funzioni pure: non usano l'orologio di sistema ne' le notifiche, quindi
/// si possono provare con orari inventati.
class NotificationScheduler {
  const NotificationScheduler._();

  /// Legge "HH:mm". Restituisce null se il testo non e' un orario valido
  /// (l'app Kotlin in quel caso usava un valore casuale: qui si salta).
  static ({int hour, int minute})? parseTime(String text) {
    final parts = text.trim().split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return (hour: hour, minute: minute);
  }

  /// Il prossimo promemoria del farmaco dopo [now], oppure null.
  ///
  /// Regole (uguali a Kotlin):
  /// - nessun promemoria se il farmaco e' in pausa o senza notifica;
  /// - per ogni orario si parte da oggi alle HH:mm;
  /// - se e' gia' passato e la frequenza e' maggiore di 0, si salta al
  ///   primo multiplo della frequenza (ore o giorni) nel futuro;
  /// - se e' passato e la frequenza e' 0, quell'orario non conta piu';
  /// - tra tutti gli orari vale il primo in ordine di tempo.
  static DateTime? nextOccurrence(Medication med, DateTime now) {
    if (!med.notificaAttiva || med.inPausa) return null;

    DateTime? best;
    for (final text in med.orari) {
      final time = parseTime(text);
      if (time == null) continue;

      var candidate =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);

      if (!candidate.isAfter(now)) {
        if (med.frequenzaValore <= 0) continue;
        candidate = _advance(candidate, now, med);
      }

      if (candidate.isAfter(now) && (best == null || candidate.isBefore(best))) {
        best = candidate;
      }
    }
    return best;
  }

  static DateTime _advance(DateTime start, DateTime now, Medication med) {
    final freq = med.frequenzaValore;
    final diff = now.difference(start);
    if (med.frequenzaTipo == FrequencyUnit.ore) {
      final steps = diff.inMilliseconds ~/ (freq * Duration.millisecondsPerHour) + 1;
      return start.add(Duration(hours: steps * freq));
    }
    final steps = diff.inMilliseconds ~/ (freq * Duration.millisecondsPerDay) + 1;
    // Si sommano giorni di calendario, cosi' l'ora resta la stessa anche
    // quando cambia l'ora legale.
    return DateTime(
        start.year, start.month, start.day + steps * freq, start.hour, start.minute);
  }

  /// I prossimi promemoria in ordine, fino a [maxCount] e non oltre
  /// [horizon]. Serve su iOS, dove le notifiche vanno programmate in anticipo.
  static List<DateTime> upcoming(
    Medication med,
    DateTime now, {
    int maxCount = 10,
    Duration horizon = const Duration(days: 14),
  }) {
    final limit = now.add(horizon);
    final result = <DateTime>[];
    var cursor = now;
    while (result.length < maxCount) {
      final next = nextOccurrence(med, cursor);
      if (next == null || next.isAfter(limit)) break;
      result.add(next);
      cursor = next;
    }
    return result;
  }

  /// Un promemoria va mostrato solo se il profilo ha le notifiche attive
  /// (stessa regola di NotificationReceiver).
  static bool shouldShow({required bool profileNotificationsOn}) =>
      profileNotificationsOn;

  /// Va riprogrammato solo se sono attivi sia il profilo sia il farmaco
  /// e il farmaco non e' in pausa.
  static bool shouldReschedule(
    Medication med, {
    required bool profileNotificationsOn,
  }) =>
      profileNotificationsOn && med.notificaAttiva && !med.inPausa;
}
