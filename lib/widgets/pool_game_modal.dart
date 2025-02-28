// lib/widgets/pool_game_modal.dart
import 'package:flutter/material.dart';
import '../utils/svg_provider.dart';

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
    selectedGameType = widget.initialGameType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 650,
          decoration: BoxDecoration(
            color: Colors.white,
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
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _canStartGame() ? _startGame : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Spiel starten',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      const Text(
                        'Spielart wählen',
                        style: TextStyle(fontSize: 22),
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

                      const Text(
                        'Match bis ...',
                        style: TextStyle(fontSize: 22),
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
                              style: const TextStyle(fontSize: 22),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(20),
                                hintText: '1-99',
                                labelText: 'Benutzerdefiniert',
                                labelStyle: TextStyle(fontSize: 20),
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

                      const Text(
                        'Breakart',
                        style: TextStyle(fontSize: 22),
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

    return Column(
      children: [
        BilliardsSVG.getBall(ballNumber, size: 60),
        const SizedBox(height: 8),
        Text('$ballNumber-Ball'),
      ],
    );
  }

  Widget _buildRaceButton(int? race) {
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
        backgroundColor:
            isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        minimumSize: const Size(70, 70),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 3,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        isCustom ? 'Benutzerdefiniert' : race.toString(),
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildBreakButton(String breakType, String label) {
    final isSelected = selectedBreak == breakType;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedBreak = breakType;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 18),
        minimumSize: const Size(0, 80),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 3,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 24),
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
