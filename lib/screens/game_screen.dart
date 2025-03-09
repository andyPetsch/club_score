// lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../widgets/score_display.dart';
import '../widgets/win_screen.dart';
import '../widgets/game_selection_modal.dart';
import '../widgets/pool_game_modal.dart';
import '../widgets/floating_control_panel.dart';
import '../widgets/straight_pool_modal.dart';

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

          // Centered floating control panel
          FloatingControlPanel(),
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
            if (gameType == 'pool') {
              _showPoolGameModal(context);
            } else if (gameType == '141') {
              _showStraightPoolModal(context);
            }
          },
        );
      },
    );
  }

  void _showPoolGameModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          child: PoolGameModal(
            onGameStart: (gameType, raceToWin, breakType) {
              // Get the GameController from provider
              final gameController =
                  Provider.of<GameController>(context, listen: false);
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

  void _showStraightPoolModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          child: StraightPoolModal(
            onGameStart: (points, innings) {
              // Get the GameController from provider
              final gameController =
                  Provider.of<GameController>(context, listen: false);
              // Handle game start
              gameController.handleNewGame({
                'gameType': '141',
                'raceToWin': points,
                'maxInnings': innings,
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
