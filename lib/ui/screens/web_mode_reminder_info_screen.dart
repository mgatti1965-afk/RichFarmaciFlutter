import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../theme/app_theme.dart';

class WebModeReminderInfoScreen extends ConsumerWidget {
  const WebModeReminderInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(telemetryProvider).track('web_reminder_action_blocked', params: {
      'source': 'direct_route',
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promemoria non disponibili'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_off, size: 64, color: AppColors.orangeAlert),
              const SizedBox(height: 16),
              const Text(
                'Funzione disponibile nelle versioni native Android e iOS nativa.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Torna alla Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
