import '../data/models/medication.dart';

/// Decisione D3: si mantiene il pre-popolamento dell'app Kotlin.
/// Se questo codice fiscale viene salvato in un profilo senza farmaci,
/// vengono aggiunti i farmaci di esempio. Per toglierlo basta svuotare
/// questa costante (o cancellare questo file e il suo uso).
const String specialCodiceFiscale = 'CLLRNN40M59L957V';

/// Confronto come nell'app Kotlin: senza spazi e in maiuscolo.
bool isSpecialCodiceFiscale(String cf) =>
    cf.replaceAll(' ', '').toUpperCase() == specialCodiceFiscale;

/// I 7 farmaci di esempio, identici a quelli dell'app Kotlin.
List<Medication> defaultMedications(String profileId) => [
      Medication(profileId: profileId, nome: 'Zanedip 10 mg', scatole: 2),
      Medication(profileId: profileId, nome: 'Lasix 25 mg', scatole: 4),
      Medication(profileId: profileId, nome: 'Pantoprazolo 20 mg'),
      Medication(profileId: profileId, nome: 'Cardioaspirina 100 mg'),
      Medication(profileId: profileId, nome: 'Zyloric 100 mg'),
      Medication(profileId: profileId, nome: 'Tareg 160 mg'),
      Medication(profileId: profileId, nome: 'Dibase 50.000 u.i./2,5ml'),
    ];
