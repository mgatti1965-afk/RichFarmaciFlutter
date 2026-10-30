import '../data/models/enums.dart';
import '../data/models/medication.dart';
import 'notification_scheduler.dart';

/// Un promemoria da programmare sul telefono.
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.when,
    required this.repeatsDaily,
  });

  /// Numero che identifica la notifica sul telefono.
  final int id;

  /// Quando deve suonare (ora locale).
  final DateTime when;

  /// Vero se si ripete ogni giorno alla stessa ora, senza fine.
  final bool repeatsDaily;

  @override
  bool operator ==(Object other) =>
      other is PlannedReminder &&
      other.id == id &&
      other.when == when &&
      other.repeatsDaily == repeatsDaily;

  @override
  int get hashCode => Object.hash(id, when, repeatsDaily);

  @override
  String toString() => 'PlannedReminder($id, $when, daily: $repeatsDaily)';
}

/// Decide quali notifiche programmare per un farmaco. Funzioni pure,
/// senza telefono: si provano con orari inventati.
///
/// - "Ogni giorno" (frequenza 1 giorno): una ripetizione giornaliera per
///   ogni orario. Dura nel tempo anche se l'app resta chiusa.
/// - Tutti gli altri casi (ogni N giorni, ogni N ore, nessuna ripetizione):
///   i prossimi [maxOneShot] promemoria singoli. Vanno rinnovati quando
///   l'app si apre (iOS ammette circa 64 notifiche in attesa in tutto).
class ReminderPlanner {
  const ReminderPlanner._();

  /// Posti riservati a ogni farmaco: ogni notifica ha id = base + posto.
  static const int slotsPerMedication = 16;

  /// Numero di base del farmaco. Si calcola dal suo id con un algoritmo
  /// fisso (FNV-1a), cosi' resta uguale a ogni avvio dell'app e si possono
  /// annullare le notifiche anche dopo un riavvio.
  static int baseId(String medicationId) {
    var hash = 0x811c9dc5;
    for (final unit in medicationId.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    // 26 bit spostati di 4: sta in un intero a 31 bit ed e' multiplo di 16.
    return (hash & 0x3FFFFFF) << 4;
  }

  /// Tutti gli id che il farmaco puo' usare (da annullare insieme).
  static List<int> allIds(String medicationId) {
    final base = baseId(medicationId);
    return List<int>.generate(slotsPerMedication, (i) => base + i);
  }

  /// Promemoria da programmare adesso. Vuoto se il farmaco e' in pausa o
  /// senza promemoria acceso.
  static List<PlannedReminder> plan(
    Medication med,
    DateTime now, {
    int maxOneShot = 6,
    Duration horizon = const Duration(days: 30),
  }) {
    if (!med.notificaAttiva || med.inPausa) return const [];
    final base = baseId(med.id);

    final isDaily = med.frequenzaTipo == FrequencyUnit.giorni &&
        med.frequenzaValore == 1;
    if (isDaily) {
      final result = <PlannedReminder>[];
      final seen = <String>{};
      for (final text in med.orari) {
        if (result.length >= slotsPerMedication) break;
        final time = NotificationScheduler.parseTime(text);
        if (time == null) continue;
        if (!seen.add('${time.hour}:${time.minute}')) continue;
        var when =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
        if (!when.isAfter(now)) {
          when = DateTime(
              now.year, now.month, now.day + 1, time.hour, time.minute);
        }
        result.add(PlannedReminder(
          id: base + result.length,
          when: when,
          repeatsDaily: true,
        ));
      }
      return result;
    }

    final upcoming = NotificationScheduler.upcoming(
      med,
      now,
      maxCount: maxOneShot > slotsPerMedication ? slotsPerMedication : maxOneShot,
      horizon: horizon,
    );
    return [
      for (var i = 0; i < upcoming.length; i++)
        PlannedReminder(id: base + i, when: upcoming[i], repeatsDaily: false),
    ];
  }
}
