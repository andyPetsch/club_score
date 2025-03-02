// lib/widgets/floating_control_panel.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../utils/svg_provider.dart';
import '../widgets/game_selection_modal.dart';
import '../widgets/pool_game_modal.dart';
import '../theme/theme_provider.dart';

class FloatingControlPanel extends StatelessWidget {
  const FloatingControlPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);
    final state = gameController.state;

    // Determine which ball to display based on game type
    int ballNumber;
    switch (state.gameType) {
      case '8ball':
        ballNumber = 8;
        break;
      case '9ball':
        ballNumber = 9;
        break;
      case '10ball':
        ballNumber = 10;
        break;
      case '141':
        ballNumber = 14;
        break;
      default:
        ballNumber = 9; // Default to 9-ball
    }

    return Positioned(
      top: 20, // Space from the top edge
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Game ball display - large circular button
          Material(
            elevation: 8,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: InkWell(
              onTap: () {
                _showGameSelectionModal(context, gameController);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: BilliardsSVG.getBall(ballNumber, size: 96),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Undo button - smaller circular button
          Material(
            elevation: 4,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: InkWell(
              onTap: () {
                // Will be implemented later
                print('Undo button tapped');
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.undo_rounded,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),

          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          )
        ],
      ),
    );
  }

  // Method to show game selection modal
  void _showGameSelectionModal(
      BuildContext context, GameController gameController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GameSelectionModal(
          onGameSelected: (gameType) {
            Navigator.of(context).pop(); // Close the dialog
            if (gameType == 'pool') {
              _showPoolGameModal(context, gameController);
            } else if (gameType == '141') {
              // to be implemented: _showStraightPoolModal(context);
            }
          },
        );
      },
    );
  }

  // Method to show pool game modal
  void _showPoolGameModal(BuildContext context, GameController gameController) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          child: PoolGameModal(
            onGameStart: (gameType, raceToWin, breakType) {
              // Handle game start
              gameController.handleNewGame({
                'gameType': gameType,
                'raceToWin': raceToWin,
                'breakType': breakType
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
