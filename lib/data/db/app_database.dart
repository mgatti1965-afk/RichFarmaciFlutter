import 'package:drift/drift.dart';

// Il codice generato (app_database.g.dart) usa queste costanti come valori
// predefiniti delle colonne, quindi vanno importate anche qui.
import '../models/defaults.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Profiles, Medications, SentRequests])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // Senza questo SQLite ignora le relazioni: cancellando un profilo
          // restarebbero farmaci e storico "orfani".
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Cancella tutti i dati (profili, farmaci, storico).
  Future<void> deleteAllData() => transaction(() async {
        await delete(sentRequests).go();
        await delete(medications).go();
        await delete(profiles).go();
      });
}
