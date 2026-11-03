import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Mostra una finestra di conferma accessibile per operazioni critiche o di cancellazione.
/// Conforme a 07_linee_guida_anziani.txt: pulsanti grandi (min 56dp), etichette esplicite
/// ("Sì, cancella" / "No, annulla") e il pulsante sicuro/annulla è evidenziato per evitare errori.
Future<bool> showConfirmDeleteDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Sì, cancella',
  String cancelLabel = 'No, annulla',
  bool isDanger = true,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: [
          Icon(
            isDanger ? Icons.warning_amber_rounded : Icons.info_outline,
            color: isDanger ? AppColors.orangeAlert : AppColors.greenPrimary,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.slate900,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
          color: AppColors.slate900,
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      actions: [
        // Il pulsante "No, annulla" è sicuro ed evidente per l'anziano
        OutlinedButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(120, 56),
            side: const BorderSide(color: AppColors.slate600, width: 2),
            foregroundColor: AppColors.slate900,
          ),
          child: Text(
            cancelLabel,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        // Il pulsante di conferma cancellazione
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(120, 56),
            backgroundColor: isDanger ? AppColors.redDanger : AppColors.greenPrimary,
            foregroundColor: AppColors.white,
          ),
          child: Text(
            confirmLabel,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

