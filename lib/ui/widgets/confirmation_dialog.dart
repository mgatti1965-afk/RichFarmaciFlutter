import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Mostra una finestra di conferma accessibile per operazioni critiche o di cancellazione.
/// Conforme a 07_linee_guida_anziani.txt: pulsanti grandi (min 56dp), etichette esplicite
/// ("Sì, cancella" / "No, annulla") e il pulsante sicuro/annulla è evidenziato per evitare errori.
Future<bool> showConfirmDeleteDialog({
  required BuildContext context,
  required String title,
  String? message,
  Widget? content,
  String confirmLabel = 'Sì, cancella',
  String cancelLabel = 'No, annulla',
  bool isDanger = true,
}) async {
  assert(message != null || content != null);
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
      content: content ??
          Text(
            message ?? '',
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.slate900,
              height: 1.4,
            ),
          ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            // Il pulsante "No, annulla" è sicuro ed evidente per l'anziano
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  side: const BorderSide(color: AppColors.slate600, width: 2),
                  foregroundColor: AppColors.slate900,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    cancelLabel,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Il pulsante di conferma cancellazione
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  backgroundColor: isDanger ? AppColors.redDanger : AppColors.greenPrimary,
                  foregroundColor: AppColors.white,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    confirmLabel,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return result ?? false;
}

