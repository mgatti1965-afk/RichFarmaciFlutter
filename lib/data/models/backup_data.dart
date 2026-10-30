import 'dart:convert';

import 'json_helpers.dart';
import 'medication.dart';
import 'profile.dart';
import 'sent_request.dart';

/// Contenuto del file di archivio (backup).
///
/// Versione 1 = formato dell'app Kotlin (date come testo italiano).
/// Versione 2 = formato della nuova app (date ISO-8601).
/// L'import accetta entrambe; l'export scrive sempre la versione 2.
class BackupData {
  BackupData({
    this.version = currentVersion,
    this.profiles = const [],
    this.medications = const [],
    this.sentRequests = const [],
    this.donationCount = 0,
    this.onboardingShown = true,
    this.disclaimerAccepted = true,
  });

  static const int currentVersion = 2;

  /// Legge un backup da testo JSON. Lancia [FormatException] se il file
  /// non e' un archivio valido o e' di una versione piu' recente.
  factory BackupData.parse(String text) {
    final Object? decoded;
    try {
      decoded = jsonDecode(text);
    } on FormatException {
      throw const FormatException('Il file non è un archivio valido.');
    }
    if (decoded is! Map) {
      throw const FormatException('Il file non è un archivio valido.');
    }
    return BackupData.fromJson(Map<String, dynamic>.from(decoded));
  }

  factory BackupData.fromJson(Map<String, dynamic> json) {
    final version = readInt(json, 'version', 1);
    if (version > currentVersion) {
      throw const FormatException(
        'Questo archivio è stato creato da una versione più recente '
        "dell'app. Aggiorna l'app e riprova.",
      );
    }

    // Per le richieste con data illeggibile si usa una data molto vecchia,
    // aumentata di un secondo per ciascuna, cosi' l'ordine del file resta.
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    final requests = <SentRequest>[];
    for (final item in readObjectList(json, 'sentRequests')) {
      requests.add(SentRequest.fromJson(
        item,
        fallbackDate: epoch.add(Duration(seconds: requests.length)),
      ));
    }

    return BackupData(
      version: version,
      profiles: readObjectList(json, 'profiles').map(Profile.fromJson).toList(),
      medications:
          readObjectList(json, 'medications').map(Medication.fromJson).toList(),
      sentRequests: requests,
      donationCount: readInt(json, 'donationCount', 0),
      onboardingShown: readBool(json, 'onboardingShown', true),
      disclaimerAccepted: readBool(json, 'disclaimerAccepted', true),
    );
  }

  final int version;
  final List<Profile> profiles;
  final List<Medication> medications;
  final List<SentRequest> sentRequests;
  final int donationCount;
  final bool onboardingShown;
  final bool disclaimerAccepted;

  Map<String, dynamic> toJson() => {
        'version': currentVersion,
        'profiles': profiles.map((p) => p.toJson()).toList(),
        'medications': medications.map((m) => m.toJson()).toList(),
        'sentRequests': sentRequests.map((r) => r.toJson()).toList(),
        'donationCount': donationCount,
        'onboardingShown': onboardingShown,
        'disclaimerAccepted': disclaimerAccepted,
      };

  /// Testo JSON indentato, pronto da salvare nel file di archivio.
  String toJsonString() =>
      const JsonEncoder.withIndent('  ').convert(toJson());
}
