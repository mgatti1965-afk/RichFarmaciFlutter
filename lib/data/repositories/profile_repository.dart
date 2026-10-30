import '../db/app_database.dart';
import '../db/mappers.dart';
import '../models/profile.dart';

class ProfileRepository {
  ProfileRepository(this._db);

  final AppDatabase _db;

  Stream<List<Profile>> watchAll() => _db
      .select(_db.profiles)
      .watch()
      .map((rows) => rows.map((r) => r.toModel()).toList());

  Future<List<Profile>> getAll() async =>
      (await _db.select(_db.profiles).get()).map((r) => r.toModel()).toList();

  Future<Profile?> getById(String id) async {
    final row = await (_db.select(_db.profiles)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row?.toModel();
  }

  /// Inserisce il profilo, oppure lo sostituisce se l'id esiste gia'.
  Future<void> save(Profile profile) =>
      _db.into(_db.profiles).insertOnConflictUpdate(profileCompanion(profile));

  /// Cancella il profilo. Farmaci e storico collegati spariscono con lui.
  Future<void> delete(String id) =>
      (_db.delete(_db.profiles)..where((t) => t.id.equals(id))).go();
}
