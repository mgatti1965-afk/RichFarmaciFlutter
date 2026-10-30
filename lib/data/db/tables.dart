import 'package:drift/drift.dart';

import '../models/defaults.dart';

/// Tabelle del database. Le classi di riga si chiamano *Row per non
/// confondersi con i modelli (Profile, Medication, SentRequest).

@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get pazienteNome => text().withDefault(const Constant(''))();
  TextColumn get pazienteCf => text().withDefault(const Constant(''))();
  TextColumn get medicoNome => text().withDefault(const Constant(''))();
  TextColumn get medicoTelefono => text().withDefault(const Constant(''))();
  TextColumn get medicoEmail => text().withDefault(const Constant(''))();
  TextColumn get secondoIndirizzo => text().withDefault(const Constant(''))();
  TextColumn get messaggioTesta =>
      text().withDefault(const Constant(defaultMessaggioTesta))();
  TextColumn get messaggioCoda =>
      text().withDefault(const Constant(defaultMessaggioCoda))();

  /// 0 = WhatsApp, 1 = SMS, 2 = Email (vedi SendChannel).
  IntColumn get tipoInvio => integer().withDefault(const Constant(0))();
  BoolColumn get notificheAttive =>
      boolean().withDefault(const Constant(false))();
  TextColumn get descrizioneNotifica =>
      text().withDefault(const Constant(defaultDescrizioneNotifica))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MedicationRow')
@TableIndex(name: 'index_medications_profileId', columns: {#profileId})
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get nome => text()();
  IntColumn get scatole => integer().withDefault(const Constant(1))();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get inPausa => boolean().withDefault(const Constant(false))();
  BoolColumn get notificaAttiva =>
      boolean().withDefault(const Constant(false))();
  TextColumn get orarioNotifica =>
      text().withDefault(const Constant(defaultOrarioNotifica))();
  IntColumn get frequenzaValore => integer().withDefault(const Constant(1))();

  /// "ORE" oppure "GIORNI" (vedi FrequencyUnit).
  TextColumn get frequenzaTipo =>
      text().withDefault(const Constant('GIORNI'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SentRequestRow')
@TableIndex(name: 'index_sent_requests_profileId', columns: {#profileId})
class SentRequests extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();

  /// Momento reale dell'invio: permette un ordinamento corretto.
  DateTimeColumn get sentAt => dateTime()();
  TextColumn get pazienteNome => text()();
  TextColumn get medicoNome => text()();

  /// Elenco dei farmaci inviati, in JSON.
  TextColumn get farmaciJson => text().withDefault(const Constant('[]'))();
  TextColumn get testoCompleto => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
