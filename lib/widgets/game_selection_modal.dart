// lib/widgets/game_selection_modal.dart
import 'package:flutter/material.dart';

class GameSelectionModal extends StatelessWidget {
  final Function(String) onGameSelected;

  const GameSelectionModal({Key? key, required this.onGameSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Spielmodus wählen',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGameModeButton(
                  context,
                  title: 'Pool',
                  subtitle: '8-, 9-, 10-Ball',
                  onTap: () => onGameSelected('pool'),
                ),
                const SizedBox(width: 16),
                _buildGameModeButton(
                  context,
                  title: '14.1 endlos',
                  isDisabled: true,
                  onTap: () {}, // Placeholder
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGameModeButton(
                  context,
                  title: 'Training',
                  isDisabled: true,
                  onTap: () {}, // Placeholder
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeButton(
    BuildContext context, {
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: isDisabled ? null : onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: isDisabled
                        ? Colors.grey
                        : Theme.of(context).textTheme.headlineLarge?.color,
                  ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDisabled ? Colors.grey.shade500 : null,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
