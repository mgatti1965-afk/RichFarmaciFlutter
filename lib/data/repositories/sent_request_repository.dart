import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../db/mappers.dart';
import '../models/sent_request.dart';

class SentRequestRepository {
  SentRequestRepository(this._db);

  final AppDatabase _db;

  /// Storico del profilo, dal piu' recente al piu' vecchio.
  Stream<List<SentRequest>> watchByProfile(String profileId) =>
      (_db.select(_db.sentRequests)
            ..where((t) => t.profileId.equals(profileId))
            ..orderBy([(t) => OrderingTerm.desc(t.sentAt)]))
          .watch()
          .map((rows) => rows.map((r) => r.toModel()).toList());

  Future<List<SentRequest>> getAll() async =>
      (await _db.select(_db.sentRequests).get())
          .map((r) => r.toModel())
          .toList();

  Future<void> save(SentRequest request) => _db
      .into(_db.sentRequests)
      .insertOnConflictUpdate(sentRequestCompanion(request));

  Future<void> delete(String id) =>
      (_db.delete(_db.sentRequests)..where((t) => t.id.equals(id))).go();
}
