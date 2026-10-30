import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/core/uuid.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/italian_date.dart';
import 'package:richfarmaci/data/models/medication.dart';
import 'package:richfarmaci/data/models/profile.dart';
import 'package:richfarmaci/data/models/sent_medication.dart';
import 'package:richfarmaci/domain/sample_medications.dart';

void main() {
  group('enum', () {
    test('SendChannel usa gli stessi codici di Kotlin', () {
      expect(SendChannel.fromCode(0), SendChannel.whatsapp);
      expect(SendChannel.fromCode(1), SendChannel.sms);
      expect(SendChannel.fromCode(2), SendChannel.email);
      expect(SendChannel.fromCode(99), SendChannel.whatsapp);
    });

    test('FrequencyUnit: solo "ORE" e\' ore, il resto giorni', () {
      expect(FrequencyUnit.fromCode('ORE'), FrequencyUnit.ore);
      expect(FrequencyUnit.fromCode('GIORNI'), FrequencyUnit.giorni);
      expect(FrequencyUnit.fromCode('boh'), FrequencyUnit.giorni);
    });
  });

  group('uuid', () {
    test('formato v4 valido e valori diversi', () {
      final a = generateUuid();
      final b = generateUuid();
      expect(
        a,
        matches(RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        )),
      );
      expect(a, isNot(b));
    });
  });

  group('valori predefiniti (uguali a Kotlin)', () {
    test('Profile', () {
      final p = Profile();
      expect(p.id, isNotEmpty);
      expect(p.tipoInvio, SendChannel.whatsapp);
      expect(p.notificheAttive, isFalse);
      expect(p.messaggioCoda,
          'La ringrazio per la disponibilità. Cordiali saluti.');
      expect(p.descrizioneNotifica, 'È ora di prendere il farmaco');
      expect(p.messaggioTesta, startsWith('Gentile Dottore,'));
    });

    test('Medication', () {
      final m = Medication(profileId: 'p', nome: 'X');
      expect(m.scatole, 1);
      expect(m.orarioNotifica, '08:00');
      expect(m.frequenzaValore, 1);
      expect(m.frequenzaTipo, FrequencyUnit.giorni);
      expect(m.inPausa, isFalse);
    });

    test('Medication.orari ignora voci vuote', () {
      final m = Medication(
          profileId: 'p', nome: 'X', orarioNotifica: '08:00, ,20:30,');
      expect(m.orari, ['08:00', '20:30']);
    });
  });

  group('SentMedication serializzazione', () {
    test('round-trip con caratteri speciali', () {
      const list = [
        SentMedication(nome: 'A|B', scatole: 2, note: 'nota #1'),
        SentMedication(nome: 'C', scatole: 1),
      ];
      final text = SentMedication.serializeList(list);
      expect(SentMedication.deserializeList(text), list);
    });

    test('stringa vuota -> lista vuota', () {
      expect(SentMedication.deserializeList(''), isEmpty);
      expect(SentMedication.deserializeList('   '), isEmpty);
    });

    test('quantita\' non numerica -> 1; senza nota -> vuota', () {
      final r = SentMedication.deserializeList('Nome###abc');
      expect(r.single, const SentMedication(nome: 'Nome', scatole: 1));
    });

    test('elementi senza separatore vengono scartati', () {
      expect(SentMedication.deserializeList('solo testo'), isEmpty);
    });

    test('formato identico a Kotlin', () {
      final text = SentMedication.serializeList(const [
        SentMedication(nome: 'Lasix', scatole: 4, note: 'x'),
        SentMedication(nome: 'Tareg', scatole: 1),
      ]);
      expect(text, 'Lasix###4###x|||Tareg###1###');
    });
  });

  group('parseItalianDate', () {
    test('formato scritto da Kotlin', () {
      expect(parseItalianDate('15 giu 2026, Ore 15:30'),
          DateTime(2026, 6, 15, 15, 30));
    });

    test('mese abbreviato con punto', () {
      expect(parseItalianDate('3 gen. 2025, Ore 08:05'),
          DateTime(2025, 1, 3, 8, 5));
    });

    test('mese per esteso e separatore diverso', () {
      expect(parseItalianDate('15 Giugno 2026 - 15:30'),
          DateTime(2026, 6, 15, 15, 30));
    });

    test('tutti i mesi', () {
      const mesi = [
        'gen', 'feb', 'mar', 'apr', 'mag', 'giu',
        'lug', 'ago', 'set', 'ott', 'nov', 'dic'
      ];
      for (var i = 0; i < mesi.length; i++) {
        expect(parseItalianDate('1 ${mesi[i]} 2026, Ore 10:00')!.month, i + 1);
      }
    });

    test('testo non valido -> null', () {
      expect(parseItalianDate(''), isNull);
      expect(parseItalianDate('ieri'), isNull);
      expect(parseItalianDate('15 xyz 2026, Ore 15:30'), isNull);
      expect(parseItalianDate('15 giu 2026, Ore 25:30'), isNull);
    });
  });

  group('farmaci di esempio (D3)', () {
    test('codice fiscale speciale: ignora spazi e maiuscole', () {
      expect(isSpecialCodiceFiscale('cll rnn40m59 l957v'), isTrue);
      expect(isSpecialCodiceFiscale('RSSMRA40A01H501Z'), isFalse);
    });

    test('7 farmaci con le quantita\' di Kotlin', () {
      final list = defaultMedications('p1');
      expect(list.length, 7);
      expect(list.every((m) => m.profileId == 'p1'), isTrue);
      expect(list[0].nome, 'Zanedip 10 mg');
      expect(list[0].scatole, 2);
      expect(list[1].scatole, 4);
      expect(list.skip(2).every((m) => m.scatole == 1), isTrue);
    });
  });
}
