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
                : null, // Kein Rahmen wenn inaktiv
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score-Anzeige
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: constraints.maxHeight * 0.9,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              '$displayedScore',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Spielername mit Break-Indikator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isBreaking)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.sports_cricket,
                          color: Colors.blue,
                          size: 28), // Größeres Icon für bessere Sichtbarkeit
                    ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20, // Größere Schrift für bessere Lesbarkeit
                      ),
                      decoration: InputDecoration(
                        hintText: 'Spieler ${playerIndex + 1}',
                        hintStyle: const TextStyle(fontSize: 20),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal:
                                12), // Mehr Platz für bessere Touch-Ziele
                      ),
                      controller: TextEditingController(text: playerName),
                      onChanged: (value) => gameController.handleAction({
                        'type': 'UPDATE_NAME',
                        'player': playerIndex + 1,
                        'name': value,
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
