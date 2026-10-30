/// Backup nel formato esatto scritto dall'app Kotlin (Moshi, versione 1).
const String kotlinBackup = '''
{
  "version": 1,
  "profiles": [
    {
      "id": "p1",
      "pazienteNome": "Mario Rossi",
      "pazienteCf": "RSSMRA40A01H501Z",
      "medicoNome": "Dott. Bianchi",
      "medicoTelefono": "+393331234567",
      "medicoEmail": "bianchi@example.com",
      "secondoIndirizzo": "",
      "messaggioTesta": "Gentile Dottore,",
      "messaggioCoda": "Grazie.",
      "tipoInvio": 2,
      "notificheAttive": true,
      "descrizioneNotifica": "Prendi la pastiglia"
    }
  ],
  "medications": [
    {
      "id": "m1",
      "profileId": "p1",
      "nome": "Lasix 25 mg",
      "scatole": 4,
      "note": "a digiuno",
      "inPausa": false,
      "notificaAttiva": true,
      "orarioNotifica": "08:00,20:00",
      "frequenzaValore": 12,
      "frequenzaTipo": "ORE"
    }
  ],
  "sentRequests": [
    {
      "id": "r1",
      "profileId": "p1",
      "data": "15 giu 2026, Ore 15:30",
      "pazienteNome": "Mario Rossi",
      "medicoNome": "Dott. Bianchi",
      "farmaciSerialized": "Lasix 25 mg###4###a digiuno|||Tareg 160 mg###1###",
      "testoCompleto": "Testo del messaggio"
    }
  ],
  "donationCount": 3,
  "onboardingShown": true,
  "disclaimerAccepted": true
}
''';
