// lib/widgets/foul_indicator.dart
import 'package:flutter/material.dart';
import '../utils/svg_provider.dart';

class FoulIndicator extends StatelessWidget {
  final int consecutiveFouls;
  final bool isActivePlayer;

  const FoulIndicator({
    Key? key,
    required this.consecutiveFouls,
    this.isActivePlayer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Don't show anything if no fouls
    if (consecutiveFouls == 0) return SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Foul X markers in a row (centered)
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            // Only show up to 2 icons
            consecutiveFouls > 2 ? 2 : consecutiveFouls,
            (_) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child:
                  BilliardsSVG.getIcon('foul_x', size: 24, color: Colors.red),
            ),
          ),
        ),

        // Warning message for active player with 2 fouls
        if (consecutiveFouls == 2 && isActivePlayer)
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              border: Border.all(color: Colors.orange.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BilliardsSVG.getIcon('warning', size: 16, color: Colors.orange),
                SizedBox(width: 4),
                Text(
                  'Nächstes Foul: -15',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
