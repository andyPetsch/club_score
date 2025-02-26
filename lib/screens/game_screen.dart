// lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/score_display.dart';
import '../widgets/win_screen.dart';
import '../widgets/game_selection_modal.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);
    final state = gameController.state;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Score displays
              Expanded(
                child: Row(
                  children: [
                    ScoreDisplay(
                      playerIndex: 0,
                      isActive: state.activePlayer == 1,
                      isBreaking: state.breakingPlayer == 1,
                    ),
                    ScoreDisplay(
                      playerIndex: 1,
                      isActive: state.activePlayer == 2,
                      isBreaking: state.breakingPlayer == 2,
                    ),
                  ],
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.undo),
                      label: const Text('Undo'),
                      onPressed: gameController.stateHistory.isEmpty
                          ? null
                          : () => gameController.handleAction({'type': 'UNDO'}),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Win Screen Overlay
          if (state.winner != null)
            WinScreen(
              winner: state.playerNames[state.winner! - 1],
              onDismiss: () {
                _showNewGameDialog(context, gameController);
              },
            ),
        ],
      ),
    );
  }

  void _showNewGameDialog(BuildContext context, GameController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GameSelectionModal(
          onGameSelected: (gameType) {
            Navigator.of(context).pop(); // Close the dialog
            // _showPoolGameSetup(context, controller, gameType);
          },
        );
      },
    );
  }
}
