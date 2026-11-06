import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/profile.dart';
import '../data/models/sent_request.dart';
import '../domain/message_builder.dart';
import '../domain/send_uri_builder.dart';
import 'providers.dart';
import 'state_providers.dart';

/// Composizione e invio della richiesta al medico, e storico.
class RequestController {
  RequestController(this._ref);

  final Ref _ref;

  Future<Profile?> _activeProfile() async {
    final id = _ref.read(activeProfileIdProvider);
    if (id == null) return null;
    return _ref.read(profileRepositoryProvider).getById(id);
  }

  /// Testo della richiesta con i farmaci scelti. Null senza profilo attivo.
  Future<String?> buildMessage() async {
    final profile = await _activeProfile();
    if (profile == null) return null;
    final meds =
        await _ref.read(medicationRepositoryProvider).getByProfile(profile.id);
    return buildRequestMessage(
      settings: profile.toSettings(),
      medications: meds,
      selection: _ref.read(requestSelectionProvider),
    );
  }

  /// Messaggio libero con i dati del paziente. Null senza profilo attivo.
  Future<String?> buildQuickMessage(String customText) async {
    final profile = await _activeProfile();
    if (profile == null) return null;
    return buildQuickMessageText(profile, customText);
  }

  /// Link per aprire WhatsApp, SMS o email col testo gia' pronto,
  /// secondo il canale scelto nel profilo. Null senza profilo attivo.
  Future<String?> buildSendUri(String message, {bool? ios}) async {
    final profile = await _activeProfile();
    if (profile == null) return null;
    final isIos = ios ?? (defaultTargetPlatform == TargetPlatform.iOS);
    return SendUriBuilder.forSettings(profile.toSettings(), message, ios: isIos);
  }

  /// Salva la richiesta nello storico con l'ora attuale e svuota la scelta.
  /// Null se non c'e' un profilo attivo.
  Future<SentRequest?> recordSent(String messageText) async {
    final profile = await _activeProfile();
    if (profile == null) return null;
    final meds =
        await _ref.read(medicationRepositoryProvider).getByProfile(profile.id);
    final request = buildSentRequest(
      profileId: profile.id,
      settings: profile.toSettings(),
      medications: meds,
      selection: _ref.read(requestSelectionProvider),
      messageText: messageText,
      now: _ref.read(clockProvider)(),
    );
    await _ref.read(sentRequestRepositoryProvider).save(request);
    _ref.read(requestSelectionProvider.notifier).clear();
    return request;
  }

  /// Apre WhatsApp, SMS o email col testo pronto. Restituisce vero se
  /// l'app e' stata aperta. Non salva nulla nello storico: lo si fa con
  /// [recordSent] solo se l'apertura e' riuscita.
  Future<bool> openSendApp(String message, {bool? ios}) async {
    final isIos = ios ?? (defaultTargetPlatform == TargetPlatform.iOS);
    final uri = await buildSendUri(message, ios: isIos);
    if (uri == null) {
      _ref.read(telemetryProvider).track('message_send_failed', params: {
        'reason': 'uri_not_available',
      });
      return false;
    }
    final opened = await _ref.read(linkOpenerProvider).open(uri);
    if (opened) {
      _ref.read(telemetryProvider).track('message_sent_to_doctor');
    } else {
      _ref.read(telemetryProvider).track('message_send_failed', params: {
        'reason': 'cannot_open_channel',
      });
    }
    return opened;
  }

  /// Invia la richiesta in un colpo solo: compone il testo, apre l'app e,
  /// se si e' aperta, salva la voce nello storico. Restituisce la voce
  /// salvata, oppure null se non c'e' un profilo o l'app non si e' aperta.
  Future<SentRequest?> sendRequest({bool? ios}) async {
    final isIos = ios ?? (defaultTargetPlatform == TargetPlatform.iOS);
    final message = await buildMessage();
    if (message == null) return null;
    if (!await openSendApp(message, ios: isIos)) return null;
    return recordSent(message);
  }

  Future<void> deleteHistoryItem(String requestId) =>
      _ref.read(sentRequestRepositoryProvider).delete(requestId);
}

String buildQuickMessageText(Profile profile, String customText) =>
    buildQuickMessage(profile.toSettings(), customText);

final requestControllerProvider =
    Provider<RequestController>((ref) => RequestController(ref));
