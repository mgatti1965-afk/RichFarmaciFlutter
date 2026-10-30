import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/medication.dart';
import 'package:richfarmaci/data/models/patient_settings.dart';
import 'package:richfarmaci/data/models/sent_medication.dart';
import 'package:richfarmaci/domain/message_builder.dart';
import 'package:richfarmaci/domain/request_selection.dart';

Medication med(String id, String nome, {int scatole = 1, String note = ''}) =>
    Medication(id: id, profileId: 'p', nome: nome, scatole: scatole, note: note);

const settings = PatientSettings(
  pazienteNome: 'Mario Rossi',
  pazienteCf: 'rssmra40a01h501z',
  medicoNome: 'Dott. Bianchi',
  messaggioTesta: '  Gentile Dottore,  ',
  messaggioCoda: '  Grazie.  ',
);

void main() {
  final lasix = med('a', 'Lasix 25 mg', scatole: 4, note: 'a digiuno');
  final tareg = med('b', 'Tareg 160 mg');
  final all = [lasix, tareg];

  group('RequestSelection', () {
    test('selezionare precompila quantita\' standard e nota vuota', () {
      final s = RequestSelection.empty.toggle(lasix);
      expect(s.isSelected('a'), isTrue);
      expect(s.quantityFor(lasix), 4);
      expect(s.noteFor(lasix), '');
    });

    test('deselezionare cancella quantita\' e nota', () {
      final s = RequestSelection.empty
          .toggle(lasix)
          .setQuantity('a', 9)
          .setNote('a', 'x')
          .toggle(lasix);
      expect(s.isSelected('a'), isFalse);
      expect(s.quantities, isEmpty);
      expect(s.notes, isEmpty);
    });

    test('la quantita\' minima e\' 1', () {
      final s = RequestSelection.empty.toggle(tareg).setQuantity('b', 0);
      expect(s.quantityFor(tareg), 1);
      final z = RequestSelection.empty.toggle(med('z', 'Z', scatole: 0));
      expect(z.quantities['z'], 1);
    });

    test('update: quantita\' 0 deseleziona, positiva seleziona', () {
      var s = RequestSelection.empty.update(tareg, 3);
      expect(s.isSelected('b'), isTrue);
      expect(s.quantityFor(tareg), 3);
      s = s.update(tareg, 0);
      expect(s.isSelected('b'), isFalse);
      expect(RequestSelection.empty.update(tareg, 0).isEmpty, isTrue);
    });

    test('lo stato e\' immutabile', () {
      const base = RequestSelection.empty;
      base.toggle(lasix);
      expect(base.isEmpty, isTrue);
    });
  });

  group('buildRequestMessage', () {
    test('formato completo', () {
      final sel = RequestSelection.empty.toggle(lasix).toggle(tareg);
      final text = buildRequestMessage(
          settings: settings, medications: all, selection: sel);
      expect(
        text,
        'Gentile Dottore,\n\n'
        '- Lasix 25 mg: 4 scatole (a digiuno)\n\n'
        '- Tareg 160 mg: 1 scatola\n\n'
        'Nome Paziente: Mario Rossi\n'
        'Codice Fiscale: RSSMRA40A01H501Z\n\n'
        'Grazie.',
      );
    });

    test('nota fissa e temporanea insieme', () {
      final sel = RequestSelection.empty.toggle(lasix).setNote('a', 'urgente');
      final text = buildRequestMessage(
          settings: settings, medications: all, selection: sel);
      expect(text, contains('- Lasix 25 mg: 4 scatole (a digiuno - urgente)'));
    });

    test('solo nota temporanea', () {
      final sel = RequestSelection.empty.toggle(tareg).setNote('b', 'subito');
      final text = buildRequestMessage(
          settings: settings, medications: all, selection: sel);
      expect(text, contains('- Tareg 160 mg: 1 scatola (subito)'));
    });

    test('senza farmaci: niente elenco', () {
      final text = buildRequestMessage(
          settings: settings,
          medications: all,
          selection: RequestSelection.empty);
      expect(
        text,
        'Gentile Dottore,\n\n'
        'Nome Paziente: Mario Rossi\n'
        'Codice Fiscale: RSSMRA40A01H501Z\n\n'
        'Grazie.',
      );
    });

    test('testa e coda vuote vengono omesse', () {
      final text = buildRequestMessage(
        settings: settings.copyWith(messaggioTesta: '  ', messaggioCoda: ''),
        medications: all,
        selection: RequestSelection.empty,
      );
      expect(text, 'Nome Paziente: Mario Rossi\nCodice Fiscale: RSSMRA40A01H501Z');
    });

    test('ignora i farmaci non selezionati e rispetta l\'ordine della lista', () {
      final sel = RequestSelection.empty.toggle(tareg).toggle(lasix);
      final text = buildRequestMessage(
          settings: settings, medications: all, selection: sel);
      expect(text.indexOf('Lasix'), lessThan(text.indexOf('Tareg')));
    });
  });

  group('messaggio veloce e storico', () {
    test('messaggio veloce', () {
      expect(
        buildQuickMessage(settings, 'Ricetta pronta?'),
        'Messaggio da Mario Rossi (CF: rssmra40a01h501z):\n\nRicetta pronta?',
      );
    });

    test('farmaci dello storico con note unite da " - "', () {
      final sel = RequestSelection.empty
          .toggle(lasix)
          .setNote('a', 'urgente')
          .toggle(tareg)
          .setQuantity('b', 2);
      expect(buildSentMedications(all, sel), const [
        SentMedication(nome: 'Lasix 25 mg', scatole: 4, note: 'a digiuno - urgente'),
        SentMedication(nome: 'Tareg 160 mg', scatole: 2),
      ]);
    });

    test('buildSentRequest', () {
      final sel = RequestSelection.empty.toggle(tareg);
      final now = DateTime(2026, 6, 15, 15, 30);
      final r = buildSentRequest(
        profileId: 'p',
        settings: settings,
        medications: all,
        selection: sel,
        messageText: 'testo',
        now: now,
      );
      expect(r.profileId, 'p');
      expect(r.sentAt, now);
      expect(r.pazienteNome, 'Mario Rossi');
      expect(r.medicoNome, 'Dott. Bianchi');
      expect(r.testoCompleto, 'testo');
      expect(r.farmaci.single.nome, 'Tareg 160 mg');
    });

    test('canale di default e\' WhatsApp', () {
      expect(const PatientSettings().tipoInvio, SendChannel.whatsapp);
    });
  });
}
