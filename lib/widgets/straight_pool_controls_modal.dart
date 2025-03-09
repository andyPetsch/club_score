// lib/widgets/straight_pool_controls_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../utils/svg_provider.dart';
import '../theme/app_themes.dart';

class StraightPoolControlsModal extends StatefulWidget {
  final String activePlayerName;
  final int currentInning;
  final int currentBreak;

  const StraightPoolControlsModal({
    Key? key,
    required this.activePlayerName,
    required this.currentInning,
    required this.currentBreak,
  }) : super(key: key);

  @override
  _StraightPoolControlsModalState createState() =>
      _StraightPoolControlsModalState();
}

class _StraightPoolControlsModalState extends State<StraightPoolControlsModal> {
  bool _isFoul = false;

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);
    final state = gameController.state;
    final ThemeData theme = Theme.of(context);
    final themeExt = theme.extension<BilliardsThemeExtension>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: themeExt?.playerCardColor ?? Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with player name and inning info
            Text(
              '${widget.activePlayerName} ist am Tisch',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8.0),
            // Inning info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: themeExt?.scoreBackgroundColor ?? Colors.grey[200]!,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '${state.maxInnings != null ? "${widget.currentInning}/${state.maxInnings}" : widget.currentInning}. Aufnahme',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: themeExt?.scoreBackgroundColor ?? Colors.grey[200]!,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'aktuelles Break: ${widget.currentBreak} Pkt.',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Remaining Balls Grid
            Text(
              'Verbleibende Kugeln auf dem Tisch',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16.0),
            // Grid of balls
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: themeExt?.scoreBackgroundColor ?? Colors.grey[200]!,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final ballSize =
                      (availableWidth / 7) - 10; // 7 balls per row with spacing

                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.center,
                    children: List.generate(14, (index) {
                      final ballNumber = index + 2; // Balls from 2 to 15
                      final isInactive = ballNumber > 15;

                      return GestureDetector(
                        onTap: isInactive
                            ? null
                            : () => _handleBallTap(ballNumber),
                        child: Container(
                          width: ballSize,
                          height: ballSize,
                          child: BilliardsSVG.getBall(
                            ballNumber,
                            size: ballSize,
                            inactive: isInactive,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),

            // Action buttons (Rerack and Foul toggle)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rerack button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleRerack(),
                    icon: Icon(Icons.refresh),
                    label: const Text('Rerack'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          themeExt?.playerCardColor ?? Colors.white,
                      foregroundColor: theme.textTheme.bodyLarge?.color,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      side: BorderSide(
                        color: theme.dividerColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Foul toggle
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: _isFoul
                          ? Colors.red.shade50
                          : themeExt?.playerCardColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color:
                            _isFoul ? Colors.red.shade300 : theme.dividerColor,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Foul',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight:
                                _isFoul ? FontWeight.bold : FontWeight.normal,
                            color: _isFoul
                                ? Colors.red.shade700
                                : theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Switch(
                          value: _isFoul,
                          onChanged: (value) {
                            setState(() {
                              _isFoul = value;
                            });
                          },
                          activeColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleBallTap(int ballNumber) {
    Navigator.of(context).pop();

    // Get the GameController
    final gameController = Provider.of<GameController>(context, listen: false);

    // Dispatch action to controller
    gameController.handleAction({
      'type': 'BALL_CLICK',
      'ballNumber': ballNumber,
      'isFoul': _isFoul,
    });
  }

  void _handleRerack() {
    Navigator.of(context).pop();

    // Get the GameController
    final gameController = Provider.of<GameController>(context, listen: false);

    // Dispatch rerack action
    gameController.handleAction({
      'type': 'RERACK',
    });
  }
}
