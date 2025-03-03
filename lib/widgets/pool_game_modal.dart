// lib/widgets/pool_game_modal.dart
import 'package:flutter/material.dart';
import '../utils/svg_provider.dart';
import '../theme/app_themes.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';

const String CUSTOM_RACE = 'custom';

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
  bool _leagueSettingsLoaded = false;
  bool isLeagueRace = false;
  int? leagueRaceValue;

  @override
  void initState() {
    super.initState();
    selectedGameType = widget.initialGameType;
    selectedRace = null;
    selectedBreak = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only load settings once
    if (!_leagueSettingsLoaded) {
      _loadLeagueSettings();
      _leagueSettingsLoaded = true;
    }
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
                      backgroundColor:
                          themeExt?.selectedItemBorder ?? primaryColor,
                      disabledBackgroundColor: disabledColor,
                      foregroundColor: Colors.white,
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
                        color: Colors.white,
                      ),
                    ),
                  )),

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
                          _buildRaceButton(CUSTOM_RACE),
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

    // Get billiards theme extension
    final themeExt = theme.extension<BilliardsThemeExtension>();

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
          _loadLeagueSettings();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? themeExt?.selectedItemBorder ?? primaryColor
                : borderColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? themeExt?.selectedItemBackground ??
                  primaryColor.withOpacity(0.2)
              : cardColor,
        ),
        child: Column(
          children: [
            BilliardsSVG.getBall(ballNumber, size: 60),
            const SizedBox(height: 8),
            Text(
              '$ballNumber-Ball',
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRaceButton(dynamic race) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;
    final Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color cardColor = theme.cardColor;
    final Color borderColor = theme.dividerColor;

    // Get billiards theme extension
    final themeExt = theme.extension<BilliardsThemeExtension>();

    final isCustom = race == CUSTOM_RACE;
    final isSelected = race == selectedRace || (isCustom && showCustomRace);
    final bool isLeagueTarget = isLeagueRace && race == leagueRaceValue;

    return Container(
      margin: EdgeInsets.only(
          top: 20, right: 0), // to allow for league target indicator
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ElevatedButton(
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
              backgroundColor: isSelected
                  ? themeExt?.selectedItemBackground ??
                      primaryColor.withOpacity(0.2)
                  : cardColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              minimumSize: const Size(70, 70),
              side: BorderSide(
                color: isLeagueTarget
                    ? Colors.blue.shade700
                    : (isSelected
                        ? themeExt?.selectedItemBorder ?? primaryColor
                        : borderColor),
                width: isLeagueTarget ? 4 : 3,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isCustom ? 'Benutzerdefiniert' : race.toString(),
              style: TextStyle(
                fontSize: 24,
                color: textColor,
                fontWeight: isSelected || isLeagueTarget
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),

          // League indicator badge
          if (isLeagueTarget)
            Positioned(
              top: -20,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "⭐ Liga",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBreakButton(String breakType, String label) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;
    final Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color cardColor = theme.cardColor;
    final Color borderColor = theme.dividerColor;

    // Get billiards theme extension
    final themeExt = theme.extension<BilliardsThemeExtension>();

    final isSelected = selectedBreak == breakType;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedBreak = breakType;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? themeExt?.selectedItemBackground ?? primaryColor.withOpacity(0.2)
            : cardColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 18),
        minimumSize: const Size(0, 80),
        side: BorderSide(
          color: isSelected
              ? themeExt?.selectedItemBorder ?? primaryColor
              : borderColor,
          width: 3,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 24,
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
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

  Future<void> _loadLeagueSettings() async {
    final gameController = Provider.of<GameController>(context, listen: false);

    if (gameController.state.selectedAssociation != null &&
        gameController.state.selectedLeagueId != null) {
      // Set the selected game type if not already set
      selectedGameType = selectedGameType ?? '9ball';

      // Get targets for the selected game type
      final targets = await gameController.leagueService.getTargets(
        gameController.state.selectedAssociation!,
        gameController.state.selectedLeagueId!,
        selectedGameType!,
      );

      if (targets != null) {
        setState(() {
          if (selectedGameType == '141' && targets is Map) {
            leagueRaceValue = targets['points'];
            selectedRace = leagueRaceValue;
          } else if (targets is int) {
            leagueRaceValue = targets;
            selectedRace = leagueRaceValue;
          }

          isLeagueRace = true;
          selectedBreak = 'alternating';
        });
      }
    }
  }
}
