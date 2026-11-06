import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/flags_providers.dart';
import '../../app/providers.dart';
import '../theme/app_theme.dart';

class DonationDialog extends ConsumerStatefulWidget {
  const DonationDialog({super.key});

  @override
  ConsumerState<DonationDialog> createState() => _DonationDialogState();
}

class _DonationDialogState extends ConsumerState<DonationDialog> {
  bool _isTestMode = false;
  final TextEditingController _passwordController = TextEditingController();
  bool _showPasswordInput = false;
  bool _passwordError = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _launchPayPal(bool isTest) async {
    final baseUrl = isTest
        ? 'https://www.sandbox.paypal.com/cgi-bin/webscr'
        : 'https://www.paypal.com/cgi-bin/webscr';

    final url =
        '$baseUrl?cmd=_xclick&business=marco.gatti65@alice.it&amount=5.00&currency_code=EUR&item_name=Offerta%20Caffe%20RichFarmaci&solution_type=Sole&landing_page=Billing';

    final opened = await ref.read(linkOpenerProvider).open(url);
    if (opened && !isTest) {
      await ref.read(donationCountProvider.notifier).increment();
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(donationCountProvider);
    final isBlocked = count >= 2;
    final hasWarning = count == 1;

    if (_showPasswordInput) {
      return AlertDialog(
        title: const Text('Modalità Test Sandbox'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Sandbox',
                errorText: _passwordError ? 'Password errata' : null,
              ),
              onSubmitted: (val) {
                if (val.trim() == 'Nidama01') {
                  setState(() {
                    _isTestMode = true;
                    _showPasswordInput = false;
                  });
                } else {
                  setState(() => _passwordError = true);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => _showPasswordInput = false),
            child: const Text('ANNULLA'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_passwordController.text.trim() == 'Nidama01') {
                setState(() {
                  _isTestMode = true;
                  _showPasswordInput = false;
                });
              } else {
                setState(() => _passwordError = true);
              }
            },
            child: const Text('ENTRA'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: GestureDetector(
        onLongPress: () {
          setState(() {
            _passwordError = false;
            _passwordController.clear();
            _showPasswordInput = true;
          });
        },
        child: Row(
          children: [
            Text(isBlocked ? 'Grazie di cuore! ☕' : 'Offri un caffè ☕'),
            if (_isTestMode)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  '(TEST)',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
          ],
        ),
      ),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(isBlocked ? 'CHIUDI' : 'ANNULLA'),
        ),
        if (!isBlocked)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenPrimary,
              foregroundColor: AppColors.white,
            ),
            onPressed: () => _launchPayPal(_isTestMode),
            child: const Text(
              'SOSTIENI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
