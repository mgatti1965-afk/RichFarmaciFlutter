import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Apre il database sul telefono (file "richfarmaci" nella cartella
/// privata dell'app). Nei test si usa invece un database in memoria.
QueryExecutor openAppConnection() => driftDatabase(
  name: 'richfarmaci',
  web: DriftWebOptions(
    sqlite3Wasm: Uri.parse('sqlite3.wasm'),
    driftWorker: Uri.parse('drift_worker.js'),
  ),
);
