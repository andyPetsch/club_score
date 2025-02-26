// lib/controllers/game_controller.dart
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/pool_game_logic.dart';

class GameController extends ChangeNotifier {
  GameState state = GameState.defaultState();
  final PoolGameLogic gameLogic = PoolGameLogic();
  List<GameState> stateHistory = [];

  GameController() {
    gameLogic.setStateContext(state);
  }

  void handleAction(Map<String, dynamic> action) {
    // Save current state before modification
    stateHistory.add(state.clone());

    // Set state context for game logic
    gameLogic.setStateContext(state);

    switch (action['type']) {
      case 'SCORE':
        int player = action['player'];
        if (state.scores[player - 1] < state.raceToWin) {
          gameLogic.increaseScore(player);
          if (gameLogic.checkWinCondition(player)) {
            state.winner = player;
          }
        }
        break;

      case 'UPDATE_NAME':
        state.playerNames[action['player'] - 1] = action['name'];
        break;

      case 'UNDO':
        if (stateHistory.isNotEmpty) {
          state = stateHistory.removeLast();
          gameLogic.setStateContext(state);
        }
        break;
    }

    notifyListeners();
  }

  void handleNewGame(Map<String, dynamic> config) {
    state = GameState(
      playerNames: state.playerNames,
      scores: [0, 0],
      winner: null,
      activePlayer: 1,
      breakType: config['breakType'] ?? 'alternating',
      breakingPlayer: 1,
      gameType: config['gameType'] ?? '9ball',
      raceToWin: config['raceToWin'] ?? 5,
    );

    stateHistory = [];
    gameLogic.setStateContext(state);
    notifyListeners();
  }
}
