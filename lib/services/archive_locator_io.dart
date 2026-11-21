import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lastBackupPathKey = 'last_backup_path';

/// Memorizza l'ultimo percorso locale usato per salvare il backup,
/// se corrisponde a un file leggibile su disco.
Future<void> rememberSavedArchivePath(String? path) async {
  if (path == null || path.isEmpty || path.startsWith('content://')) return;
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastBackupPathKey, path);
  } catch (_) {
    // Best-effort: non blocca il salvataggio se SharedPreferences fallisce.
  }
}

/// Cerca il file di backup [fileName] nei percorsi accessibili del dispositivo
/// e ne restituisce il testo UTF-8, oppure null se non presente o non leggibile.
Future<String?> findExistingArchiveText(String fileName) async {
  final candidates = <String>[];

  try {
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getString(_lastBackupPathKey);
    if (remembered != null && remembered.isNotEmpty) {
      candidates.add(remembered);
    }
  } catch (_) {}

  try {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      candidates.add(p.join(downloadsDir.path, fileName));
    }
  } catch (_) {}

  try {
    final docsDir = await getApplicationDocumentsDirectory();
    candidates.add(p.join(docsDir.path, fileName));
  } catch (_) {}

  if (Platform.isAndroid) {
    candidates.add('/storage/emulated/0/Download/$fileName');
    candidates.add('/storage/emulated/0/Documents/$fileName');
  }

  final seen = <String>{};
  for (final path in candidates) {
    if (!seen.add(path)) continue;
    try {
      final file = File(path);
      if (!await file.exists()) continue;
      final bytes = await file.readAsBytes();
      final text = utf8.decode(bytes);
      return text.startsWith('\uFEFF') ? text.substring(1) : text;
    } catch (_) {
      // Ignora percorsi non accessibili (es. Scoped Storage su Android) o corrotti.
    }
  }
  return null;
}
