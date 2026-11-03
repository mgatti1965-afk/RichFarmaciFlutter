import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({
    super.key,
    required this.type,
    required this.onDismiss,
  });

  /// 'richiesta', 'cronologia', oppure 'configurazione'
  final String type;
  final VoidCallback onDismiss;

  String get title {
    switch (type) {
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
        ElevatedButton(
          onPressed: onDismiss,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(120, 56),
            backgroundColor: AppColors.greenPrimary,
          ),
          child: const Text('Ho capito', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  List<Widget> _buildItems() {
    switch (type) {
      case 'richiesta':
        return const [
          _HelpBullet(text: 'Scegli il paziente dalla barra in alto (se ne gestisci più di uno).'),
          _HelpBullet(text: 'Seleziona i farmaci toccando la casella o il nome.'),
          _HelpBullet(text: 'Regola il numero di scatole con i pulsanti grandi + e - .'),
          _HelpBullet(text: 'Premi "INVIA RICHIESTA AL MEDICO" per trasmettere il messaggio con WhatsApp, SMS o Email.'),
          _HelpBullet(text: 'Puoi usare "MESSAGGIO VELOCE" per inviare brevi comunicazioni extra al medico (es. febbre, appuntamento).'),
        ];
      case 'cronologia':
        return const [
          _HelpBullet(text: 'Le richieste inviate sono elencate dalla più recente alla più vecchia.'),
          _HelpBullet(text: 'Tocca una richiesta per leggere il testo integrale inviato al medico.'),
          _HelpBullet(text: 'Puoi eliminare le vecchie richieste toccando il pulsante Elimina (conferma richiesta).'),
        ];
      default:
        return const [
          _HelpBullet(text: 'ANAGRAFICA: Inserisci Nome, Cognome, Codice Fiscale del paziente e i dati del Medico curante.'),
          _HelpBullet(text: 'CANALE: Scegli la modalità di invio preferita (WhatsApp, SMS o Email).'),
          _HelpBullet(text: 'PROMEMORIA: Attiva le notifiche per ricevere promemoria automatici all\'orario stabilito.'),
          _HelpBullet(text: 'GESTIONE FARMACI: Aggiungi e modifica i farmaci abituali con quantità predefinite e orari.'),
          _HelpBullet(text: 'ARCHIVIO: Esporta o importa in qualsiasi momento una copia di sicurezza di tutti i dati.'),
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

