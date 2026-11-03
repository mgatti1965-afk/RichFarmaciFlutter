import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuickMessageDialog extends StatefulWidget {
  const QuickMessageDialog({
    super.key,
    required this.onSend,
  });

  final Future<void> Function(String text) onSend;

  @override
  State<QuickMessageDialog> createState() => _QuickMessageDialogState();
}

class _QuickMessageDialogState extends State<QuickMessageDialog> {
  final _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await widget.onSend(text);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
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
          onPressed: _isSending ? null : () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _controller.text.trim().isEmpty || _isSending
              ? null
              : _handleSend,
          child: _isSending
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                )
              : const Text('INVIA'),
        ),
      ],
    );
  }
}

