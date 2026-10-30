import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/medication.dart';
import 'package:richfarmaci/domain/reminder_plan.dart';

Medication med({
  String id = 'm1',
  String orari = '08:00',
  int freq = 1,
  FrequencyUnit tipo = FrequencyUnit.giorni,
  bool attiva = true,
  bool pausa = false,
}) =>
    Medication(
      id: id,
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
  final base = ReminderPlanner.baseId('m1');

  group('id delle notifiche', () {
    test('baseId e\' stabile, nell\'intervallo e multiplo di 16', () {
      expect(ReminderPlanner.baseId('m1'), ReminderPlanner.baseId('m1'));
      for (final id in ['a', 'm1', 'f47ac10b-58cc-4372-a567-0e02b2c3d479', '']) {
        final b = ReminderPlanner.baseId(id);
        expect(b, greaterThanOrEqualTo(0));
        expect(b, lessThan(1 << 30));
        expect(b % 16, 0);
      }
    });

    test('farmaci diversi hanno basi diverse', () {
      final bases = List.generate(200, (i) => ReminderPlanner.baseId('med-$i'));
      expect(bases.toSet().length, 200);
    });

    test('allIds: 16 id consecutivi a partire dalla base', () {
      final ids = ReminderPlanner.allIds('m1');
      expect(ids.length, 16);
      expect(ids.first, base);
      expect(ids.last, base + 15);
    });
  });

  group('nessun promemoria', () {
    test('farmaco in pausa o con promemoria spento', () {
      expect(ReminderPlanner.plan(med(pausa: true), now), isEmpty);
      expect(ReminderPlanner.plan(med(attiva: false), now), isEmpty);
    });

    test('nessuna ripetizione e orario gia\' passato', () {
      expect(ReminderPlanner.plan(med(freq: 0), now), isEmpty);
    });
  });

  group('ogni giorno: ripetizione giornaliera', () {
    test('orario passato: parte domani', () {
      expect(ReminderPlanner.plan(med(), now), [
        PlannedReminder(
            id: base, when: DateTime(2026, 6, 16, 8, 0), repeatsDaily: true),
      ]);
    });

    test('orario futuro: parte oggi', () {
      expect(ReminderPlanner.plan(med(orari: '18:30'), now), [
        PlannedReminder(
            id: base, when: DateTime(2026, 6, 15, 18, 30), repeatsDaily: true),
      ]);
    });

    test('piu\' orari: una ripetizione ciascuno, id consecutivi', () {
      expect(ReminderPlanner.plan(med(orari: '08:00,20:00'), now), [
        PlannedReminder(
            id: base, when: DateTime(2026, 6, 16, 8, 0), repeatsDaily: true),
        PlannedReminder(
            id: base + 1,
            when: DateTime(2026, 6, 15, 20, 0),
            repeatsDaily: true),
      ]);
    });

    test('orari doppi e non validi vengono saltati', () {
      final plan = ReminderPlanner.plan(med(orari: 'xx,09:00,09:00, 9:00'), now);
      expect(plan.length, 1);
      expect(plan.single.id, base);
      expect(plan.single.when, DateTime(2026, 6, 16, 9, 0));
    });

    test('esattamente all\'orario: parte domani', () {
      final plan = ReminderPlanner.plan(med(orari: '10:00'), now);
      expect(plan.single.when, DateTime(2026, 6, 16, 10, 0));
    });

    test('a cavallo di fine mese', () {
      final plan = ReminderPlanner.plan(med(), DateTime(2026, 6, 30, 10, 0));
      expect(plan.single.when, DateTime(2026, 7, 1, 8, 0));
    });
  });

  group('altre frequenze: promemoria singoli', () {
    test('ogni 3 giorni: i prossimi, senza ripetizione', () {
      final plan = ReminderPlanner.plan(med(freq: 3), now, maxOneShot: 3);
      expect(plan.map((r) => r.when), [
        DateTime(2026, 6, 18, 8, 0),
        DateTime(2026, 6, 21, 8, 0),
        DateTime(2026, 6, 24, 8, 0),
      ]);
      expect(plan.every((r) => !r.repeatsDaily), isTrue);
      expect(plan.map((r) => r.id), [base, base + 1, base + 2]);
    });

    test('ogni 6 ore: sei promemoria singoli di default', () {
      final plan = ReminderPlanner.plan(
          med(freq: 6, tipo: FrequencyUnit.ore), now);
      expect(plan.length, 6);
      expect(plan.first.when, DateTime(2026, 6, 15, 14, 0));
      expect(plan[1].when, DateTime(2026, 6, 15, 20, 0));
      expect(plan.every((r) => !r.repeatsDaily), isTrue);
    });

    test('ogni ora non e\' una ripetizione giornaliera', () {
      final plan =
          ReminderPlanner.plan(med(freq: 1, tipo: FrequencyUnit.ore), now);
      expect(plan.first.when, DateTime(2026, 6, 15, 11, 0));
      expect(plan.every((r) => !r.repeatsDaily), isTrue);
    });

    test('nessuna ripetizione con orario futuro: un solo promemoria', () {
      final plan = ReminderPlanner.plan(med(orari: '18:00', freq: 0), now);
      expect(plan.length, 1);
      expect(plan.single.when, DateTime(2026, 6, 15, 18, 0));
      expect(plan.single.repeatsDaily, isFalse);
    });

    test('rispetta l\'orizzonte', () {
      final plan = ReminderPlanner.plan(med(freq: 3), now,
          horizon: const Duration(days: 7));
      expect(plan.map((r) => r.when), [
        DateTime(2026, 6, 18, 8, 0),
        DateTime(2026, 6, 21, 8, 0),
      ]);
    });

    test('non supera i 16 posti del farmaco', () {
      final plan = ReminderPlanner.plan(
          med(freq: 1, tipo: FrequencyUnit.ore), now, maxOneShot: 99);
      expect(plan.length, 16);
    });
  });
}
