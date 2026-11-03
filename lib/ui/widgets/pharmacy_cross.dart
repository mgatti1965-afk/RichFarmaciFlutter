import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Croce verde distintiva di RichFarmaci (stile farmacia).
class PharmacyCross extends StatelessWidget {
  const PharmacyCross({
    super.key,
    this.size = 32.0,
    this.color = AppColors.greenPrimary,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final barRadius = BorderRadius.circular(size * 0.08);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Barra orizzontale
          Container(
            width: size,
            height: size * 0.32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: barRadius,
            ),
          ),
          // Barra verticale
          Container(
            width: size * 0.32,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: barRadius,
            ),
          ),
        ],
      ),
    );
  }
}

