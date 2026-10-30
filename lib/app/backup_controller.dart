import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/backup_service.dart';
import '../services/archive_file_service.dart';
import 'flags_providers.dart';
import 'providers.dart';
import 'reminder_sync.dart';
import 'state_providers.dart';

/// Esporta e importa l'archivio. Il file vero e proprio (salvare, condividere,
/// scegliere) e' compito della schermata: qui si lavora sul testo.
class BackupController {
  BackupController(this._ref);

  final Ref _ref;

  /// Testo dell'archivio, pronto da salvare in un file.
  Future<String> exportJson() => _ref.read(backupServiceProvider).exportToJson();

  /// Nome suggerito per il file, es. "RichFarmaci_Archivio_2026-10-29.json".
  String suggestedFileName() {
    final d = _ref.read(clockProvider)();
    String two(int n) => n.toString().padLeft(2, '0');
    return 'RichFarmaci_Archivio_${d.year}-${two(d.month)}-${two(d.day)}.json';
  }

  /// "Esporta": crea il file e apre il menu Salva/Condividi.
  Future<ArchiveShareOutcome> exportToFile() async {
    final json = await exportJson();
    return _ref.read(archiveFileServiceProvider).share(
          fileName: suggestedFileName(),
          json: json,
        );
  }

  /// "Importa": fa scegliere il file e lo ripristina. Restituisce null se
  /// l'utente annulla la scelta. Se il file non e' valido lancia
  /// [FormatException] con un messaggio in italiano (dati intatti).
  Future<RestoreResult?> importFromFile() async {
    final text = await _ref.read(archiveFileServiceProvider).pickText();
    if (text == null) return null;
    return restoreJson(text);
  }

  /// Ripristina l'archivio. Lancia [FormatException] con un messaggio in
  /// italiano se il file non e' valido (i dati attuali restano intatti).
  /// Dopo il ripristino aggiorna profilo attivo, preferenze e promemoria.
  Future<RestoreResult> restoreJson(String text) async {
    final result = await _ref.read(backupServiceProvider).restoreFromJson(text);
    _ref.read(activeProfileIdProvider.notifier).reload();
    _ref.read(requestSelectionProvider.notifier).clear();
    reloadAllFlags(_ref);
    await _ref.read(reminderSyncProvider).syncAll();
    return result;
  }
}

final backupControllerProvider =
    Provider<BackupController>((ref) => BackupController(ref));
