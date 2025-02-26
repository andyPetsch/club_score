import 'package:flutter/material.dart';

class PoolGameModal extends StatefulWidget {
  final Function(String gameType, int raceToWin, String breakType) onGameStart;

  const PoolGameModal({Key? key, required this.onGameStart}) : super(key: key);

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 600,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
                padding: const EdgeInsets.all(20),
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
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    'Spiel starten',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              // Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Spielart wählen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Game Type Selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildGameOption('8ball', '8-Ball'),
                          _buildGameOption('9ball', '9-Ball'),
                          _buildGameOption('10ball', '10-Ball'),
                        ],
                      ),
                      const SizedBox(height: 25),

                      const Text(
                        'Match bis ...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Race Selection
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (int race in [4, 5, 6, 7, 8, 9, 10])
                            _buildRaceButton(race),
                          _buildRaceButton(null),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Custom Race Input
                      if (showCustomRace)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '1-99',
                                labelText: 'Benutzerdefiniert',
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
                      const SizedBox(height: 25),

                      const Text(
                        'Breakart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Break Selection
                      Row(
                        children: [
                          Expanded(
                            child: _buildBreakButton(
                                'alternating', 'Wechselbreak'),
                          ),
                          const SizedBox(width: 10),
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

  Widget _buildGameOption(String type, String label) {
    final isSelected = selectedGameType == type;

    return InkWell(
      onTap: () {
        setState(() {
          selectedGameType = type;
        });
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 2,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        isCustom ? 'Benutzerdefiniert' : race.toString(),
        style: const TextStyle(fontSize: 16),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 2,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
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
