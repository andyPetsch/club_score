// lib/widgets/straight_pool_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../theme/app_themes.dart';

class StraightPoolModal extends StatefulWidget {
  final Function(int points, int? innings) onGameStart;

  const StraightPoolModal({
    Key? key,
    required this.onGameStart,
  }) : super(key: key);

  @override
  _StraightPoolModalState createState() => _StraightPoolModalState();
}

class _StraightPoolModalState extends State<StraightPoolModal> {
  int? selectedPoints;
  int? selectedInnings;
  bool showCustomSettings = false;
  int? customPoints;
  int? customInnings;
  bool isLeagueTarget = false;
  Map<dynamic, dynamic>? leagueTargets;

  @override
  void initState() {
    super.initState();
    _loadLeagueSettings();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
                        '14.1 endlos Einstellungen',
                        style: TextStyle(fontSize: 24, color: textColor),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Spielmodus',
                        style: TextStyle(fontSize: 20, color: textColor),
                      ),
                      const SizedBox(height: 18),

                      // Predefined settings
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildSettingButton(50, 20),
                          _buildSettingButton(75, 25),
                          _buildSettingButton(80, 20),
                          _buildSettingButton(85, 25),
                          _buildSettingButton(90, 30),
                          _buildSettingButton(100, 30),
                          _buildSettingButton(125, null),
                          _buildSettingButton(null, null, isCustom: true),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Custom settings input
                      if (showCustomSettings)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style:
                                      TextStyle(fontSize: 20, color: textColor),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(16),
                                    labelText: 'Punkte',
                                    hintText: '1 - 9999',
                                    fillColor: cardColor,
                                    filled: true,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      try {
                                        final points = int.parse(value);
                                        if (points > 0 && points < 10000) {
                                          setState(() {
                                            customPoints = points;
                                            selectedPoints = points;
                                          });
                                        } else {
                                          setState(() {
                                            customPoints = null;
                                            selectedPoints = null;
                                          });
                                        }
                                      } catch (_) {
                                        setState(() {
                                          customPoints = null;
                                          selectedPoints = null;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        customPoints = null;
                                        selectedPoints = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  style:
                                      TextStyle(fontSize: 20, color: textColor),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(16),
                                    labelText: 'Aufnahmen',
                                    hintText: '1 - 99',
                                    fillColor: cardColor,
                                    filled: true,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      try {
                                        final innings = int.parse(value);
                                        if (innings > 0 && innings < 100) {
                                          setState(() {
                                            customInnings = innings;
                                            selectedInnings = innings;
                                          });
                                        } else {
                                          setState(() {
                                            customInnings = null;
                                            // Don't reset selectedInnings here
                                            // as null is a valid value (no innings limit)
                                          });
                                        }
                                      } catch (_) {
                                        setState(() {
                                          customInnings = null;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        customInnings = null;
                                        selectedInnings = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildSettingButton(int? points, int? innings,
      {bool isCustom = false}) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;
    final Color textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final Color cardColor = theme.cardColor;
    final Color borderColor = theme.dividerColor;

    // Get billiards theme extension
    final themeExt = theme.extension<BilliardsThemeExtension>();

    String buttonText;
    if (isCustom) {
      buttonText = 'Benutzerdefiniert';
    } else if (innings == null) {
      buttonText = '${points} Pkt. | - Aufn.';
    } else {
      buttonText = '${points} Pkt. | ${innings} Aufn.';
    }

    final bool isSelected = isCustom
        ? showCustomSettings
        : selectedPoints == points && selectedInnings == innings;

    final bool isLeague = isLeagueTarget &&
        leagueTargets != null &&
        leagueTargets!['points'] == points &&
        leagueTargets!['innings'] == innings;

    return Container(
      margin: EdgeInsets.only(top: isLeague ? 20 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isCustom) {
                  showCustomSettings = true;
                  selectedPoints = customPoints;
                  selectedInnings = customInnings;
                } else {
                  showCustomSettings = false;
                  selectedPoints = points;
                  selectedInnings = innings;
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected
                  ? themeExt?.selectedItemBackground ??
                      primaryColor.withOpacity(0.2)
                  : cardColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              side: BorderSide(
                color: isLeague
                    ? Colors.blue.shade700
                    : (isSelected
                        ? themeExt?.selectedItemBorder ?? primaryColor
                        : borderColor),
                width: isLeague ? 3 : 2,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: isSelected || isLeague
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),

          // League indicator badge
          if (isLeague)
            Positioned(
              top: -20,
              left: 0,
              right: 0,
              child: Center(
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
            ),
        ],
      ),
    );
  }

  bool _canStartGame() {
    return selectedPoints != null;
  }

  void _startGame() {
    if (_canStartGame()) {
      widget.onGameStart(
        selectedPoints!,
        selectedInnings,
      );
    }
  }

  Future<void> _loadLeagueSettings() async {
    final gameController = Provider.of<GameController>(context, listen: false);

    if (gameController.state.selectedAssociation != null &&
        gameController.state.selectedLeagueId != null) {
      // Get targets for the straight pool game type
      final targets = await gameController.leagueService.getTargets(
        gameController.state.selectedAssociation!,
        gameController.state.selectedLeagueId!,
        '141',
      );

      if (targets != null && targets is Map) {
        setState(() {
          leagueTargets = targets;
          selectedPoints = targets['points'];
          selectedInnings = targets['innings'];
          isLeagueTarget = true;
        });
      }
    }
  }
}
