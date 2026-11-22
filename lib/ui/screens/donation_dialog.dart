import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/flags_providers.dart';
import '../../app/providers.dart';
import '../theme/app_theme.dart';

class DonationDialog extends ConsumerWidget {
  const DonationDialog({super.key});

  Future<void> _launchPayPal(BuildContext context, WidgetRef ref) async {
    final url = Uri.https(
      'www.paypal.com',
      '/cgi-bin/webscr',
      {
        'cmd': '_donations',
        'business': 'marco.gatti65@alice.it',
        'amount': '5.00',
        'currency_code': 'EUR',
        'item_name': 'Offerta Caffe RichFarmaci',
      },
    ).toString();

    final messenger = ScaffoldMessenger.maybeOf(context);
    final opened = await ref.read(linkOpenerProvider).open(url);
    if (opened) {
      await ref.read(donationCountProvider.notifier).increment();
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    if (!opened) {
      messenger?.showSnackBar(
        const SnackBar(
          content: Text(
            'Impossibile aprire la pagina di pagamento.',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: AppColors.redDanger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(donationCountProvider);
    final isBlocked = count >= 2;
    final hasWarning = count == 1;

    return AlertDialog(
      title: Text(isBlocked ? 'Grazie di cuore! ☕' : 'Offri un caffè ☕'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasWarning && !isBlocked)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'ATTENZIONE: Hai già sostenuto il progetto in precedenza.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            isBlocked
                ? 'Hai già sostenuto il progetto il numero massimo di volte. Ti ringraziamo immensamente per il tuo supporto!'
                : 'Sostieni lo sviluppo di RichFarmaci con un contributo di 5€ per un buon caffè.\n\nVerrai reindirizzato su una pagina sicura gestita da PayPal dove potrai usare il tuo account o una normale carta di credito/prepagata.',
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(isBlocked ? 'CHIUDI' : 'ANNULLA'),
                ),
              ),
            ),
            if (!isBlocked) ...[
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    backgroundColor: AppColors.greenPrimary,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: () => _launchPayPal(context, ref),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'SOSTIENI',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
