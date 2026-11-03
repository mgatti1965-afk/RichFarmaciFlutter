import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pharmacy_cross.dart';

/// Finestra di benvenuto iniziale con spiegazione passo-passo semplice.
class OnboardingDialog extends StatelessWidget {
  const OnboardingDialog({
    super.key,
    required this.onDismiss,
  });

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          const PharmacyCross(size: 48),
          const SizedBox(height: 14),
          const Text(
            'Benvenuto in RichFarmaci!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'L\'assistente facile per richiedere le ricette dei tuoi farmaci al medico.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.slate600,
            ),
          ),
        ],
      ),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepItem(
              number: '1',
              title: 'Inserisci i dati',
              subtitle: 'Il tuo nome, Codice Fiscale e il contatto del tuo medico.',
            ),
            SizedBox(height: 12),
            _StepItem(
              number: '2',
              title: 'Aggiungi i farmaci',
              subtitle: 'I medicinali che prendi abitualmente, con quantità e promemoria.',
            ),
            SizedBox(height: 12),
            _StepItem(
              number: '3',
              title: 'Invia con un tocco',
              subtitle: 'Componi la richiesta e spediscila tramite WhatsApp, SMS o Email.',
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: onDismiss,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            backgroundColor: AppColors.greenPrimary,
          ),
          child: const Text(
            'INIZIA ORA',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.greenPrimary,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.slate600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
