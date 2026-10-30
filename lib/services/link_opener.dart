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
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      return false;
    }
  }
}
