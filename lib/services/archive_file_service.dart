import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

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

  /// "Importa": fa scegliere un file e ne restituisce il testo.
  /// Restituisce null se l'utente annulla.
  Future<String?> pickText();
}

class DeviceArchiveFileService implements ArchiveFileService {
  const DeviceArchiveFileService();

  @override
  Future<ArchiveShareOutcome> share({
    required String fileName,
    required String json,
  }) async {
    final bytes = utf8.encode(json);

    final result = await SharePlus.instance.share(ShareParams(
      files: [
        XFile.fromData(
          bytes,
          mimeType: 'application/json',
          name: fileName,
        ),
      ],
    ));
    switch (result.status) {
      case ShareResultStatus.success:
        return ArchiveShareOutcome.completed;
      case ShareResultStatus.dismissed:
        return ArchiveShareOutcome.dismissed;
      case ShareResultStatus.unavailable:
        return ArchiveShareOutcome.unknown;
    }
  }

  @override
  Future<String?> pickText() async {
    // Nessun filtro sul tipo: alcuni telefoni nascondono i file .json
    // quando si filtra, e chi importa deve poter scegliere il suo file.
    final file = await FilePicker.pickFile();
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
