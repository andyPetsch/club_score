// lib/widgets/pool_game_modal.dart
import 'package:flutter/material.dart';
import '../utils/svg_provider.dart';
import '../theme/app_themes.dart';

class PoolGameModal extends StatefulWidget {
  final Function(String gameType, int raceToWin, String breakType) onGameStart;
  final String? initialGameType;

  const PoolGameModal({
    Key? key,
    required this.onGameStart,
    this.initialGameType,
  }) : super(key: key);

  @override
  _PoolGameModalState createState() => _PoolGameModalState();
}

class _PoolGameModalState extends State<PoolGameModal> {
  String? selectedGameType;
  int? selectedRace;
  String? selectedBreak;
  int? customRace;
  bool showCustomRace = false;

  @override
  void initState() {
    super.initState();
    selectedGameType = widget.initialGameType ??
        '8ball'; // Default to 8ball if no initial type
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color primaryColor = theme.primaryColor;
    final Color backgroundColor = theme.cardColor;
    final Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color disabledColor = theme.disabledColor;

    // Get billiards theme extension
    final themeExt = theme.extension<BilliardsThemeExtension>();
    final Color cardColor = themeExt?.playerCardColor ?? backgroundColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 650,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: theme.dividerColor, width: 1),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _canStartGame() ? _startGame : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: disabledColor,
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: const Size.fromHeight(65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Spiel starten',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),

              // Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spielart wählen',
                        style: TextStyle(fontSize: 22, color: textColor),
                      ),
                      const SizedBox(height: 18),

                      // Game Type Selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildGameOption(context, '8ball'),
                          _buildGameOption(context, '9ball'),
                          _buildGameOption(context, '10ball'),
                        ],
                      ),
                      const SizedBox(height: 30),

                      Text(
                        'Match bis ...',
                        style: TextStyle(fontSize: 22, color: textColor),
                      ),
                      const SizedBox(height: 18),

                      // Race Selection
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          for (int race in [4, 5, 6, 7, 8, 9, 10])
                            _buildRaceButton(race),
                          _buildRaceButton(null),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Custom Race Input
                      if (showCustomRace)
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 22, color: textColor),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(20),
                                hintText: '1-99',
                                labelText: 'Benutzerdefiniert',
                                labelStyle: TextStyle(fontSize: 20),
                                fillColor: cardColor,
                                filled: true,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  try {
                                    final race = int.parse(value);
                                    if (race > 0 && race < 100) {
                                      setState(() {
                                        customRace = race;
                                        selectedRace = race;
                                      });
                                    } else {
                                      setState(() {
                                        customRace = null;
                                        selectedRace = null;
                                      });
                                    }
                                  } catch (_) {
                                    setState(() {
                                      customRace = null;
                                      selectedRace = null;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    customRace = null;
                                    selectedRace = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),

                      Text(
                        'Breakart',
                        style: TextStyle(fontSize: 22, color: textColor),
                      ),
                      const SizedBox(height: 18),

                      // Break Selection
                      Row(
                        children: [
                          Expanded(
                            child: _buildBreakButton(
                                'alternating', 'Wechselbreak'),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildBreakButton('winner', 'Winnerbreak'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOption(BuildContext context, String gameType) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;
    final Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color cardColor = theme.cardColor;
    final Color borderColor = theme.dividerColor;

    int ballNumber;
    switch (gameType) {
      case '8ball':
        ballNumber = 8;
        break;
      case '9ball':
        ballNumber = 9;
        break;
      case '10ball':
        ballNumber = 10;
        break;
      default:
        ballNumber = 8;
    }

    final isSelected = selectedGameType == gameType;

    return InkWell(
      onTap: () {
        setState(() {
          selectedGameType = gameType;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? primaryColor.withOpacity(0.1) : cardColor,
        ),
        child: Column(
          children: [
            BilliardsSVG.getBall(ballNumber, size: 60),
            const SizedBox(height: 8),
            Text(
              '$ballNumber-Ball',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRaceButton(int? race) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;
    final Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color cardColor = theme.cardColor;
    final Color borderColor = theme.dividerColor;

    final isSelected = race == selectedRace || (race == null && showCustomRace);
    final isCustom = race == null;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isCustom) {
            showCustomRace = true;
            selectedRace = customRace;
          } else {
            showCustomRace = false;
            selectedRace = race;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor.withOpacity(0.1) : cardColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        minimumSize: const Size(70, 70),
        side: BorderSide(
          color: isSelected ? primaryColor : borderColor,
          width: 3,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        isCustom ? 'Benutzerdefiniert' : race.toString(),
        style: TextStyle(fontSize: 24, color: textColor),
      ),
    );
  }

  Widget _buildBreakButton(String breakType, String label) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;
    final Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color cardColor = theme.cardColor;
    final Color borderColor = theme.dividerColor;

    final isSelected = selectedBreak == breakType;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedBreak = breakType;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor.withOpacity(0.1) : cardColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 18),
        minimumSize: const Size(0, 80),
        side: BorderSide(
          color: isSelected ? primaryColor : borderColor,
          width: 3,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 24, color: textColor),
      ),
    );
  }

  bool _canStartGame() {
    return selectedGameType != null &&
        selectedRace != null &&
        selectedBreak != null;
  }

  void _startGame() {
    if (_canStartGame()) {
      widget.onGameStart(
        selectedGameType!,
        selectedRace!,
        selectedBreak!,
      );
    }
  }
}
