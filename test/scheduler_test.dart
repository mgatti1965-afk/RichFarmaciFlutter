import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/medication.dart';
import 'package:richfarmaci/domain/notification_scheduler.dart';

Medication med({
  String orari = '08:00',
  int freq = 1,
  FrequencyUnit tipo = FrequencyUnit.giorni,
  bool attiva = true,
  bool pausa = false,
}) =>
    Medication(
      id: 'm',
      profileId: 'p',
      nome: 'X',
      notificaAttiva: attiva,
      inPausa: pausa,
      orarioNotifica: orari,
      frequenzaValore: freq,
      frequenzaTipo: tipo,
    );

void main() {
  final now = DateTime(2026, 6, 15, 10, 0);

  group('parseTime', () {
    test('orari validi', () {
      expect(NotificationScheduler.parseTime('08:05'), (hour: 8, minute: 5));
      expect(NotificationScheduler.parseTime(' 23:59 '), (hour: 23, minute: 59));
    });

    test('orari non validi', () {
      for (final t in ['', '8', '24:00', '10:60', 'ab:cd', '1:2:3', '-1:00']) {
        expect(NotificationScheduler.parseTime(t), isNull, reason: t);
      }
    });
  });

  group('nextOccurrence', () {
    test('nessun promemoria se non attivo o in pausa', () {
      expect(NotificationScheduler.nextOccurrence(med(attiva: false), now), isNull);
      expect(NotificationScheduler.nextOccurrence(med(pausa: true), now), isNull);
    });

    test('orario ancora futuro oggi', () {
      expect(NotificationScheduler.nextOccurrence(med(orari: '18:30'), now),
          DateTime(2026, 6, 15, 18, 30));
    });

    test('orario passato, ogni 1 giorno -> domani', () {
      expect(NotificationScheduler.nextOccurrence(med(), now),
          DateTime(2026, 6, 16, 8, 0));
    });

    test('orario passato, ogni 3 giorni -> tra 3 giorni', () {
      expect(NotificationScheduler.nextOccurrence(med(freq: 3), now),
          DateTime(2026, 6, 18, 8, 0));
    });

    test('orario passato, frequenza 0 -> nessun promemoria', () {
      expect(NotificationScheduler.nextOccurrence(med(freq: 0), now), isNull);
    });

    test('ogni 6 ore dalle 08:00, ora 10:00 -> 14:00', () {
      expect(
          NotificationScheduler.nextOccurrence(
              med(freq: 6, tipo: FrequencyUnit.ore), now),
          DateTime(2026, 6, 15, 14, 0));
    });

    test('ogni 12 ore dalle 08:00, ora 20:00 -> domani alle 08:00', () {
      final late = DateTime(2026, 6, 15, 20, 0);
      expect(
          NotificationScheduler.nextOccurrence(
              med(freq: 12, tipo: FrequencyUnit.ore), late),
          DateTime(2026, 6, 16, 8, 0));
    });

    test('piu\' orari: vince il primo nel tempo', () {
      expect(
          NotificationScheduler.nextOccurrence(med(orari: '08:00,13:00,20:00'), now),
          DateTime(2026, 6, 15, 13, 0));
    });

    test('piu\' orari tutti passati e frequenza 0: nessuno', () {
      expect(
          NotificationScheduler.nextOccurrence(
              med(orari: '08:00,09:00', freq: 0), now),
          isNull);
    });

    test('orari non validi vengono saltati', () {
      expect(NotificationScheduler.nextOccurrence(med(orari: 'xx, 18:00'), now),
          DateTime(2026, 6, 15, 18, 0));
      expect(NotificationScheduler.nextOccurrence(med(orari: 'xx'), now), isNull);
    });

    test('esattamente all\'orario: si passa al successivo', () {
      expect(
          NotificationScheduler.nextOccurrence(
              med(orari: '10:00'), DateTime(2026, 6, 15, 10, 0)),
          DateTime(2026, 6, 16, 10, 0));
    });

    test('a cavallo di fine mese', () {
      expect(
          NotificationScheduler.nextOccurrence(med(), DateTime(2026, 6, 30, 10, 0)),
          DateTime(2026, 7, 1, 8, 0));
    });
  });

  group('upcoming', () {
    test('elenca le occorrenze in ordine', () {
      final list = NotificationScheduler.upcoming(
          med(orari: '08:00,20:00'), now, maxCount: 4);
      expect(list, [
        DateTime(2026, 6, 15, 20, 0),
        DateTime(2026, 6, 16, 8, 0),
        DateTime(2026, 6, 16, 20, 0),
        DateTime(2026, 6, 17, 8, 0),
      ]);
    });

    test('rispetta l\'orizzonte', () {
      final list = NotificationScheduler.upcoming(med(), now,
          maxCount: 50, horizon: const Duration(days: 3));
      expect(list.length, 3);
    });

    test('vuoto se non ci sono promemoria', () {
      expect(NotificationScheduler.upcoming(med(attiva: false), now), isEmpty);
    });
  });

  group('regole profilo', () {
    test('shouldShow', () {
      expect(NotificationScheduler.shouldShow(profileNotificationsOn: true), isTrue);
      expect(NotificationScheduler.shouldShow(profileNotificationsOn: false), isFalse);
    });

    test('shouldReschedule', () {
      expect(NotificationScheduler.shouldReschedule(med(), profileNotificationsOn: true), isTrue);
      expect(NotificationScheduler.shouldReschedule(med(), profileNotificationsOn: false), isFalse);
      expect(NotificationScheduler.shouldReschedule(med(pausa: true), profileNotificationsOn: true), isFalse);
      expect(NotificationScheduler.shouldReschedule(med(attiva: false), profileNotificationsOn: true), isFalse);
    });
  });
}
