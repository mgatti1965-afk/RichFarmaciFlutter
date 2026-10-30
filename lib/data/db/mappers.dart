import 'dart:convert';

import 'package:drift/drift.dart';

import '../models/enums.dart';
import '../models/medication.dart';
import '../models/profile.dart';
import '../models/sent_medication.dart';
import '../models/sent_request.dart';
import 'app_database.dart';

/// Conversioni tra le righe del database e i modelli dell'app.

extension ProfileRowMapper on ProfileRow {
  Profile toModel() => Profile(
        id: id,
        pazienteNome: pazienteNome,
        pazienteCf: pazienteCf,
        medicoNome: medicoNome,
        medicoTelefono: medicoTelefono,
        medicoEmail: medicoEmail,
        secondoIndirizzo: secondoIndirizzo,
        messaggioTesta: messaggioTesta,
        messaggioCoda: messaggioCoda,
        tipoInvio: SendChannel.fromCode(tipoInvio),
        notificheAttive: notificheAttive,
        descrizioneNotifica: descrizioneNotifica,
      );
}

ProfilesCompanion profileCompanion(Profile p) => ProfilesCompanion(
      id: Value(p.id),
      pazienteNome: Value(p.pazienteNome),
      pazienteCf: Value(p.pazienteCf),
      medicoNome: Value(p.medicoNome),
      medicoTelefono: Value(p.medicoTelefono),
      medicoEmail: Value(p.medicoEmail),
      secondoIndirizzo: Value(p.secondoIndirizzo),
      messaggioTesta: Value(p.messaggioTesta),
      messaggioCoda: Value(p.messaggioCoda),
      tipoInvio: Value(p.tipoInvio.code),
      notificheAttive: Value(p.notificheAttive),
      descrizioneNotifica: Value(p.descrizioneNotifica),
    );

extension MedicationRowMapper on MedicationRow {
  Medication toModel() => Medication(
        id: id,
        profileId: profileId,
        nome: nome,
        scatole: scatole,
        note: note,
        inPausa: inPausa,
        notificaAttiva: notificaAttiva,
        orarioNotifica: orarioNotifica,
        frequenzaValore: frequenzaValore,
        frequenzaTipo: FrequencyUnit.fromCode(frequenzaTipo),
      );
}

MedicationsCompanion medicationCompanion(Medication m) => MedicationsCompanion(
      id: Value(m.id),
      profileId: Value(m.profileId),
      nome: Value(m.nome),
      scatole: Value(m.scatole),
      note: Value(m.note),
      inPausa: Value(m.inPausa),
      notificaAttiva: Value(m.notificaAttiva),
      orarioNotifica: Value(m.orarioNotifica),
      frequenzaValore: Value(m.frequenzaValore),
      frequenzaTipo: Value(m.frequenzaTipo.code),
    );

extension SentRequestRowMapper on SentRequestRow {
  SentRequest toModel() => SentRequest(
        id: id,
        profileId: profileId,
        sentAt: sentAt,
        pazienteNome: pazienteNome,
        medicoNome: medicoNome,
        farmaci: _decodeFarmaci(farmaciJson),
        testoCompleto: testoCompleto,
      );
}

SentRequestsCompanion sentRequestCompanion(SentRequest r) =>
    SentRequestsCompanion(
      id: Value(r.id),
      profileId: Value(r.profileId),
      sentAt: Value(r.sentAt),
      pazienteNome: Value(r.pazienteNome),
      medicoNome: Value(r.medicoNome),
      farmaciJson: Value(jsonEncode(r.farmaci.map((f) => f.toJson()).toList())),
      testoCompleto: Value(r.testoCompleto),
    );

List<SentMedication> _decodeFarmaci(String text) {
  try {
    final decoded = jsonDecode(text);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((e) => SentMedication.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  } on FormatException {
    return const [];
  }
}
