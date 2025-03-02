// lib/widgets/score_display.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../theme/app_themes.dart';

class ScoreDisplay extends StatefulWidget {
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
  _ScoreDisplayState createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final gameController = Provider.of<GameController>(context, listen: false);
    final playerName = gameController.state.playerNames[widget.playerIndex];

    _nameController = TextEditingController(text: playerName);

    // Select all text when controller is created
    _nameController.selection =
        TextSelection(baseOffset: 0, extentOffset: _nameController.text.length);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);
    final state = gameController.state;
    final int displayedScore = state.scores[widget.playerIndex];

    // Benutzerdefinierte Theme-Erweiterung abrufen
    final themeExt = Theme.of(context).extension<BilliardsThemeExtension>();
    final scoreBackground = themeExt?.scoreBackgroundColor ?? Colors.grey[200]!;
    final cardBackground = themeExt?.playerCardColor ?? Colors.white;

    return Expanded(
      child: GestureDetector(
        onTap: () => gameController.handleAction({
          'type': 'SCORE',
          'player': widget.playerIndex + 1,
        }),
        child: Container(
          decoration: BoxDecoration(
            color: cardBackground,
            border: (widget.isActive && state.gameType == '141')
                ? Border.all(color: Colors.blue, width: 3.0)
                : null,
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
                    color: scoreBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: constraints.maxHeight * 0.7,
                          width: constraints.maxWidth * 0.8,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              '$displayedScore',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
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
                  if (widget.isBreaking)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.sports_cricket,
                          color: Colors.blue, size: 28),
                    ),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Spieler ${widget.playerIndex + 1}',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).hintColor,
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                      ),
                      onTap: () {
                        _nameController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _nameController.text.length);
                      },
                      onChanged: (value) => gameController.handleAction({
                        'type': 'UPDATE_NAME',
                        'player': widget.playerIndex + 1,
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
