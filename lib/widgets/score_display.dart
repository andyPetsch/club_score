// lib/widgets/score_display.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';

class ScoreDisplay extends StatelessWidget {
  final int playerIndex;
  final bool isActive;
  final bool isBreaking;

  const ScoreDisplay({
    Key? key,
    required this.playerIndex,
    required this.isActive,
    required this.isBreaking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);
    final state = gameController.state;
    final int displayedScore = state.scores[playerIndex];
    final String playerName = state.playerNames[playerIndex];

    return Expanded(
      child: GestureDetector(
        onTap: () => gameController.handleAction({
          'type': 'SCORE',
          'player': playerIndex + 1,
        }),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: (isActive && state.gameType == '141')
                ? Border.all(color: Colors.blue, width: 3.0)
                : null, // No border when inactive
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score display
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$displayedScore',
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Player name field
              if (isBreaking) Icon(Icons.sports_cricket, color: Colors.blue),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Spieler ${playerIndex + 1}',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: playerName),
                onChanged: (value) => gameController.handleAction({
                  'type': 'UPDATE_NAME',
                  'player': playerIndex + 1,
                  'name': value,
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
