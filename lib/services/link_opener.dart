import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Apre un link in un'altra app (WhatsApp, Messaggi, posta).
abstract class LinkOpener {
  /// Restituisce vero se e' stato aperto, falso se non c'e' nessuna app
  /// in grado di aprirlo o il link non e' valido.
  Future<bool> open(String url);
}

class UrlLauncherOpener implements LinkOpener {
  const UrlLauncherOpener();

  @override
  Future<bool> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    try {
      if (kIsWeb) {
        // Su Web (Safari / iOS PWA / Chrome) i link verso app esterne
        // devono usare '_self' per non aprire schede vuote che Safari blocca.
        return await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_self',
        );
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      return false;
    }
  }
}
