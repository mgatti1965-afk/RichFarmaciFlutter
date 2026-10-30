import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/patient_settings.dart';
import 'package:richfarmaci/domain/send_uri_builder.dart';
import 'package:richfarmaci/domain/settings_rules.dart';

void main() {
  group('SendUriBuilder', () {
    test('WhatsApp: numero senza + e spazi, testo codificato', () {
      expect(
        SendUriBuilder.whatsapp('+39 333 123', 'Ciao, a/b?'),
        'https://api.whatsapp.com/send?phone=39333123&text=Ciao%2C%20a%2Fb%3F',
      );
    });

    test('WhatsApp: gli a capo diventano %0A', () {
      expect(SendUriBuilder.whatsapp('1', 'a\n\nb'), endsWith('text=a%0A%0Ab'));
    });

    test('SMS Android e iOS', () {
      expect(SendUriBuilder.sms('+393331', 'Ciao a te'),
          'sms:+393331?body=Ciao%20a%20te');
      expect(SendUriBuilder.sms('+393331', 'Ciao', ios: true),
          'sms:+393331&body=Ciao');
    });

    test('Email con oggetto e testo', () {
      expect(
        SendUriBuilder.email('m@x.it', 'Mario Rossi', 'Testo'),
        'mailto:m@x.it?subject=Comunicazione%20da%3A%20Mario%20Rossi&body=Testo',
      );
    });

    test('forSettings sceglie il canale', () {
      const base = PatientSettings(
        pazienteNome: 'M',
        medicoTelefono: '+39 1',
        medicoEmail: 'd@x.it',
      );
      expect(
        SendUriBuilder.forSettings(base, 't'),
        startsWith('https://api.whatsapp.com/send?phone=391'),
      );
      expect(
        SendUriBuilder.forSettings(base.copyWith(tipoInvio: SendChannel.sms), 't'),
        startsWith('sms:+39 1'),
      );
      expect(
        SendUriBuilder.forSettings(base.copyWith(tipoInvio: SendChannel.email), 't'),
        startsWith('mailto:d@x.it?'),
      );
    });
  });

  group('SettingsRules', () {
    test('cleanPhone', () {
      expect(SettingsRules.cleanPhone('+39 (333) 123-456'), '+39333123456');
      expect(SettingsRules.cleanPhone(' 06 12.34 '), '061234');
    });

    test('sanitize: trim, codice fiscale maiuscolo, telefono pulito', () {
      final s = SettingsRules.sanitize(const PatientSettings(
        pazienteNome: '  Mario ',
        pazienteCf: ' rssmra40a01h501z ',
        medicoNome: ' Dott. ',
        medicoTelefono: '+39 333 1',
        medicoEmail: ' a@b.it ',
        messaggioTesta: ' T ',
        messaggioCoda: ' C ',
        descrizioneNotifica: ' D ',
      ));
      expect(s.pazienteNome, 'Mario');
      expect(s.pazienteCf, 'RSSMRA40A01H501Z');
      expect(s.medicoNome, 'Dott.');
      expect(s.medicoTelefono, '+393331');
      expect(s.medicoEmail, 'a@b.it');
      expect(s.messaggioTesta, 'T');
      expect(s.messaggioCoda, 'C');
      expect(s.descrizioneNotifica, 'D');
    });

    const complete = PatientSettings(
      pazienteNome: 'M',
      pazienteCf: 'X',
      medicoNome: 'D',
      medicoTelefono: '1',
    );

    test('isComplete con telefono', () {
      expect(SettingsRules.isComplete(complete), isTrue);
      expect(SettingsRules.isComplete(complete.copyWith(medicoTelefono: ' ')),
          isFalse);
    });

    test('isComplete con email richiede l\'email, non il telefono', () {
      final email = complete.copyWith(tipoInvio: SendChannel.email);
      expect(SettingsRules.isComplete(email), isFalse);
      expect(
          SettingsRules.isComplete(email.copyWith(medicoEmail: 'a@b.it')), isTrue);
    });

    test('isComplete: mancano nome, codice fiscale o medico', () {
      expect(SettingsRules.isComplete(complete.copyWith(pazienteNome: '')), isFalse);
      expect(SettingsRules.isComplete(complete.copyWith(pazienteCf: '')), isFalse);
      expect(SettingsRules.isComplete(complete.copyWith(medicoNome: '')), isFalse);
    });

    test('missingFields in parole semplici', () {
      expect(SettingsRules.missingFields(const PatientSettings()), [
        'Il nome del paziente',
        'Il codice fiscale',
        'Il nome del medico',
        'Il telefono del medico',
      ]);
      expect(
        SettingsRules.missingFields(
            const PatientSettings(tipoInvio: SendChannel.email)),
        contains("L'email del medico"),
      );
      expect(SettingsRules.missingFields(complete), isEmpty);
    });
  });
}
