import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/data/models/backup_data.dart';
import 'package:richfarmaci/data/models/enums.dart';
import 'package:richfarmaci/data/models/sent_medication.dart';
import 'package:richfarmaci/data/models/sent_request.dart';

import 'fixtures.dart';

void main() {
  group('import del backup Kotlin (versione 1)', () {
    late BackupData data;
    setUp(() => data = BackupData.parse(kotlinBackup));

    test('profili', () {
      final p = data.profiles.single;
      expect(p.id, 'p1');
      expect(p.pazienteNome, 'Mario Rossi');
      expect(p.tipoInvio, SendChannel.email);
      expect(p.notificheAttive, isTrue);
      expect(p.descrizioneNotifica, 'Prendi la pastiglia');
    });

    test('farmaci', () {
      final m = data.medications.single;
      expect(m.profileId, 'p1');
      expect(m.scatole, 4);
      expect(m.orari, ['08:00', '20:00']);
      expect(m.frequenzaValore, 12);
      expect(m.frequenzaTipo, FrequencyUnit.ore);
    });

    test('richieste: data italiana convertita e farmaci tipizzati', () {
      final r = data.sentRequests.single;
      expect(r.sentAt, DateTime(2026, 6, 15, 15, 30));
      expect(r.farmaci, const [
        SentMedication(nome: 'Lasix 25 mg', scatole: 4, note: 'a digiuno'),
        SentMedication(nome: 'Tareg 160 mg', scatole: 1),
      ]);
      expect(r.testoCompleto, 'Testo del messaggio');
    });

    test('preferenze globali', () {
      expect(data.donationCount, 3);
      expect(data.onboardingShown, isTrue);
      expect(data.disclaimerAccepted, isTrue);
    });
  });

  group('altri casi', () {
    test('round-trip nel nuovo formato (versione 2)', () {
      final original = BackupData.parse(kotlinBackup);
      final reloaded = BackupData.parse(original.toJsonString());

      expect(jsonDecode(original.toJsonString())['version'], 2);
      expect(reloaded.profiles.single, original.profiles.single);
      expect(reloaded.medications.single, original.medications.single);
      expect(reloaded.sentRequests.single.sentAt.toUtc(),
          original.sentRequests.single.sentAt.toUtc());
      expect(reloaded.sentRequests.single.farmaci,
          original.sentRequests.single.farmaci);
      expect(reloaded.donationCount, 3);
    });

    test('campi mancanti -> valori predefiniti (come Moshi)', () {
      final data = BackupData.parse('{}');
      expect(data.version, 1);
      expect(data.profiles, isEmpty);
      expect(data.donationCount, 0);
      expect(data.onboardingShown, isTrue);
      expect(data.disclaimerAccepted, isTrue);
    });

    test('data illeggibile: conserva la richiesta e l\'ordine', () {
      final data = BackupData.parse(jsonEncode({
        'sentRequests': [
          {'id': 'a', 'profileId': 'p', 'data': 'boh', 'farmaciSerialized': ''},
          {'id': 'b', 'profileId': 'p', 'data': 'boh', 'farmaciSerialized': ''},
        ],
      }));
      expect(data.sentRequests.length, 2);
      expect(data.sentRequests[0].sentAt.isBefore(data.sentRequests[1].sentAt),
          isTrue);
    });

    test('file non JSON -> errore comprensibile', () {
      expect(
        () => BackupData.parse('questo non è un json'),
        throwsA(isA<FormatException>().having((e) => e.message, 'message',
            'Il file non è un archivio valido.')),
      );
    });

    test('JSON che non e\' un oggetto -> errore', () {
      expect(() => BackupData.parse('[1,2]'), throwsFormatException);
    });

    test('versione piu\' recente -> errore', () {
      expect(() => BackupData.parse('{"version": 99}'), throwsFormatException);
    });

    test('elementi non validi nelle liste vengono ignorati', () {
      final data = BackupData.parse(jsonEncode({
        'profiles': [
          5,
          'x',
          {'id': 'ok'}
        ],
      }));
      expect(data.profiles.single.id, 'ok');
    });

    test('SentRequest nuovo formato: sentAt ISO e lista farmaci', () {
      final r = SentRequest.fromJson({
        'id': 'z',
        'profileId': 'p',
        'sentAt': '2026-06-15T13:30:00Z',
        'farmaci': [
          {'nome': 'A', 'scatole': 2, 'note': 'n'}
        ],
      }, fallbackDate: DateTime(2000));
      expect(r.sentAt.toUtc(), DateTime.utc(2026, 6, 15, 13, 30));
      expect(r.farmaci.single,
          const SentMedication(nome: 'A', scatole: 2, note: 'n'));
    });
  });
}
