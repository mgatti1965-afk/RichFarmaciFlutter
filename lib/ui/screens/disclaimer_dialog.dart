import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Finestra obbligatoria di limitazione di responsabilità alla prima apertura dell'app.
class DisclaimerDialog extends StatelessWidget {
  const DisclaimerDialog({
    super.key,
    required this.onAccept,
  });

  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Non consente la chiusura accidentale senza presa visione
      child: AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.redDanger, size: 30),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Avviso Importante',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.redDanger,
                ),
              ),
            ),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'L’applicazione RichFarmaci ha scopo puramente gestionale e di supporto logistico personale.\n\n'
                'NON costituisce un dispositivo medico e non sostituisce in alcun modo il parere, la diagnosi o le prescrizioni del medico curante.',
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.slate900,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Punti di attenzione:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900,
                ),
              ),
              SizedBox(height: 8),
              _DisclaimerItem(text: 'Verifica sempre l\'effettivo invio del messaggio al tuo medico.'),
              _DisclaimerItem(text: 'I promemoria dipendono dalle impostazioni di risparmio energetico del tuo telefono.'),
              _DisclaimerItem(text: 'Controlla sempre che i nomi dei farmaci e le quantità siano corretti.'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: AppColors.greenPrimary,
              foregroundColor: AppColors.white,
            ),
            child: const Text(
              'ACCETTO E CONTINUA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerItem extends StatelessWidget {
  const _DisclaimerItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 20, color: AppColors.redDanger, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: AppColors.slate600, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

