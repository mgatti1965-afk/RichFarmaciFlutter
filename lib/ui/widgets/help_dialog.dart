import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../theme/app_theme.dart';

class HelpDialog extends StatefulWidget {
  const HelpDialog({
    super.key,
    required this.type,
    required this.onDismiss,
  });

  /// 'richiesta', 'cronologia', oppure 'configurazione'
  final String type;
  final VoidCallback onDismiss;

  @override
  State<HelpDialog> createState() => _HelpDialogState();
}

class _HelpDialogState extends State<HelpDialog> {
  bool _showFullManual = false;
  String _manualText = '';
  bool _loadingManual = false;

  void _loadManual() async {
    setState(() => _loadingManual = true);
    try {
      final text = await rootBundle.loadString('assets/manuale_utente.md');
      setState(() {
        _manualText = text;
        _showFullManual = true;
        _loadingManual = false;
      });
    } catch (_) {
      setState(() {
        _manualText = 'Impossibile caricare il manuale utente.';
        _showFullManual = true;
        _loadingManual = false;
      });
    }
  }

  String get title {
    switch (widget.type) {
      case 'richiesta':
        return 'Guida Richiesta Farmaci';
      case 'cronologia':
        return 'Guida Cronologia';
      default:
        return 'Guida Configurazione';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showFullManual) {
      final screenSize = MediaQuery.sizeOf(context);
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.menu_book, color: AppColors.greenPrimary, size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Manuale Utente',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: screenSize.width * 0.9,
          height: screenSize.height * 0.7,
          child: Markdown(
            data: _manualText,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.slate900,
              ),
              h1: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.slate900,
              ),
              h2: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.greenPrimary,
              ),
              h3: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.slate900,
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => setState(() => _showFullManual = false),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 56),
              backgroundColor: AppColors.greenPrimary,
            ),
            child: const Text('Indietro', style: TextStyle(fontSize: 18)),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.help_outline, color: AppColors.greenPrimary, size: 28),
          const SizedBox(width: 10),
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
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: _buildItems(),
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: _loadingManual ? null : _loadManual,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(120, 56),
            backgroundColor: AppColors.greenPrimary,
            foregroundColor: AppColors.white,
          ),
          icon: _loadingManual
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : const Icon(Icons.menu_book, size: 20, color: AppColors.white),
          label: const Text('Manuale', style: TextStyle(fontSize: 18)),
        ),
        ElevatedButton(
          onPressed: widget.onDismiss,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(120, 56),
            backgroundColor: AppColors.greenPrimary,
            foregroundColor: AppColors.white,
          ),
          child: const Text('Ho capito', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  List<Widget> _buildItems() {
    switch (widget.type) {
      case 'richiesta':
        return const [
          _HelpBullet(
            text:
                'Scegli il paziente dalla barra in alto (se ne gestisci più di uno).',
          ),
          _HelpBullet(
            text: 'Seleziona i farmaci toccando la casella o il nome.',
          ),
          _HelpBullet(
            text: 'Regola il numero di scatole con i pulsanti grandi + e - .',
          ),
          _HelpBullet(
            text:
                'Premi "INVIA RICHIESTA AL MEDICO" per trasmettere il messaggio con WhatsApp, SMS o Email.',
          ),
          _HelpBullet(
            text:
                'Puoi usare "MESSAGGIO VELOCE" per inviare brevi comunicazioni extra al medico (es. febbre, appuntamento).',
          ),
        ];
      case 'cronologia':
        return const [
          _HelpBullet(
            text:
                'Le richieste inviate sono elencate dalla più recente alla più vecchia.',
          ),
          _HelpBullet(
            text:
                'Tocca una richiesta per leggere il testo integrale inviato al medico.',
          ),
          _HelpBullet(
            text:
                'Puoi eliminare le vecchie richieste toccando il pulsante Elimina (conferma richiesta).',
          ),
        ];
      default:
        return const [
          _HelpBullet(
            text:
                'ANAGRAFICA: Inserisci Nome, Cognome, Codice Fiscale del paziente e i dati del Medico curante.',
          ),
          _HelpBullet(
            text:
                'CANALE: Scegli la modalità di invio preferita (WhatsApp, SMS o Email).',
          ),
          _HelpBullet(
            text:
                'PROMEMORIA: Attiva le notifiche per ricevere promemoria automatici all\'orario stabilito.',
          ),
          _HelpBullet(
            text:
                'GESTIONE FARMACI: Aggiungi e modifica i farmaci abituali con quantità predefinite e orari.',
          ),
          _HelpBullet(
            text:
                'ARCHIVIO: Esporta o importa in qualsiasi momento una copia di sicurezza di tutti i dati.',
          ),
        ];
    }
  }
}

class _HelpBullet extends StatelessWidget {
  const _HelpBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.greenPrimary,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                color: AppColors.slate900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
