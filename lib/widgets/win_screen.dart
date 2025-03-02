// lib/widgets/win_screen.dart
import 'package:flutter/material.dart';

class WinScreen extends StatelessWidget {
  final String winner;
  final VoidCallback onDismiss;

  const WinScreen({Key? key, required this.winner, required this.onDismiss})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Prevent taps from passing through
      onTap: () {},
      child: Container(
        color: Colors.white.withOpacity(0.7),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Glückwunsch,\n$winner!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
