import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'archive_locator_stub.dart'
    if (dart.library.io) 'archive_locator_io.dart';

/// Com'e' finita la condivisione del file di archivio.
enum ArchiveShareOutcome {
  /// L'utente ha scelto dove salvarlo o a chi mandarlo.
  completed,

  /// L'utente ha chiuso il menu senza scegliere.
  dismissed,

  /// Il telefono non dice com'e' andata (succede su alcuni sistemi).
  unknown,
}

/// Salva e legge il file di archivio. E' un'interfaccia cosi' i test
/// possono usare una versione finta.
abstract class ArchiveFileService {
  /// "Esporta": crea il file e apre il menu Salva/Condividi.
  Future<ArchiveShareOutcome> share({
    required String fileName,
    required String json,
  });

  /// "Importa": cerca se esiste già un file di backup con nome [fileName]
  /// in un percorso accessibile e ne restituisce il testo, altrimenti null.
  Future<String?> findExistingText(String fileName);

  /// "Importa": fa scegliere un file e ne restituisce il testo.
  /// Restituisce null se l'utente annulla.
  Future<String?> pickText({String? suggestedFileName});
}

class DeviceArchiveFileService implements ArchiveFileService {
  const DeviceArchiveFileService();

  @override
  Future<ArchiveShareOutcome> share({
    required String fileName,
    required String json,
  }) async {
    final bytes = Uint8List.fromList(utf8.encode(json));

    final savedUri = await FilePicker.saveFile(
      dialogTitle: 'Salva configurazione',
      fileName: fileName,
      bytes: bytes,
      mimeType: 'application/json',
    );
    if (savedUri != null && savedUri.scheme == 'file') {
      await rememberSavedArchivePath(savedUri.toFilePath());
    }
    return savedUri != null
        ? ArchiveShareOutcome.completed
        : ArchiveShareOutcome.dismissed;
  }

  @override
  Future<String?> findExistingText(String fileName) =>
      findExistingArchiveText(fileName);

  @override
  Future<String?> pickText({String? suggestedFileName}) async {
    // Nessun filtro sul tipo: alcuni telefoni nascondono i file .json
    // quando si filtra, e chi importa deve poter scegliere il suo file.
    final file = await FilePicker.pickFile(
      dialogTitle: suggestedFileName != null
          ? 'Seleziona $suggestedFileName'
          : null,
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    final String text;
    try {
      text = utf8.decode(bytes);
    } on FormatException {
      throw const FormatException('Il file non è un archivio valido.');
    }
    // Alcuni programmi aggiungono un segno invisibile all'inizio del file.
    return text.startsWith('\uFEFF') ? text.substring(1) : text;
  }
}
