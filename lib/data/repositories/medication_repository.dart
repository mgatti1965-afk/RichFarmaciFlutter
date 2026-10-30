import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../db/mappers.dart';
import '../models/medication.dart';

class MedicationRepository {
  MedicationRepository(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$MedicationsTable, MedicationRow> _byProfile(
          String profileId) =>
      _db.select(_db.medications)
        ..where((t) => t.profileId.equals(profileId))
        ..orderBy([(t) => OrderingTerm.asc(t.nome)]);

  /// Farmaci del profilo in ordine alfabetico, aggiornati in tempo reale.
  Stream<List<Medication>> watchByProfile(String profileId) => _byProfile(
          profileId)
      .watch()
      .map((rows) => rows.map((r) => r.toModel()).toList());

  Future<List<Medication>> getByProfile(String profileId) async =>
      (await _byProfile(profileId).get()).map((r) => r.toModel()).toList();

  Future<List<Medication>> getAll() async =>
      (await _db.select(_db.medications).get()).map((r) => r.toModel()).toList();

  /// Inserisce o sostituisce (stesso id).
  Future<void> save(Medication med) => _db
      .into(_db.medications)
      .insertOnConflictUpdate(medicationCompanion(med));

  Future<void> saveAll(List<Medication> meds) => _db.batch((b) {
        b.insertAllOnConflictUpdate(
            _db.medications, meds.map(medicationCompanion).toList());
      });

  Future<void> delete(String id) =>
      (_db.delete(_db.medications)..where((t) => t.id.equals(id))).go();
}
