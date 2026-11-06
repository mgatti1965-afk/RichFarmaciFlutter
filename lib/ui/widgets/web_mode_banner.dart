import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class WebModeBanner extends StatelessWidget {
  const WebModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.sandAlertBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orangeAlert),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.orangeAlert),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Versione web: promemoria automatici non disponibili.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.slate900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
