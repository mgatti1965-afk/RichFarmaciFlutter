import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuickMessageDialog extends StatefulWidget {
  const QuickMessageDialog({
    super.key,
    this.onSend,
  });

  /// Callback opzionale: se fornita viene invocata dopo la chiusura del dialogo.
  final Future<void> Function(String text)? onSend;

  @override
  State<QuickMessageDialog> createState() => _QuickMessageDialogState();
}

class _QuickMessageDialogState extends State<QuickMessageDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Chiudi subito questo dialogo restituendo il testo per evitare collisioni
    // di navigazione con il popup di conferma ("Messaggio Inviato").
    Navigator.of(context).pop(text);
    widget.onSend?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.chat_bubble_outline, color: AppColors.greenPrimary, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Messaggio Veloce',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.slate900,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Invia una breve comunicazione al medico (es. febbre, richiesta visita). I tuoi dati anagrafici verranno inseriti automaticamente.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.slate600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 18, color: AppColors.slate900),
              decoration: const InputDecoration(
                labelText: 'Scrivi qui il tuo messaggio',
                alignLabelWithHint: true,
                hintText: 'Es: Ho qualche linea di febbre...',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _controller.text.trim().isEmpty ? null : _handleSend,
          child: const Text('INVIA'),
        ),
      ],
    );
  }
}

