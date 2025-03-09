// lib/controllers/game_controller.dart
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/pool_game_logic.dart';
import '../services/league_service.dart';
import '../models/straight_pool_game_logic.dart';

class GameController extends ChangeNotifier {
  GameState state = GameState.defaultState();

  final defaultGameLogic = PoolGameLogic();
  final PoolGameLogic poolGameLogic = PoolGameLogic();
  final StraightPoolGameLogic straightPoolGameLogic = StraightPoolGameLogic();
  final LeagueService leagueService = LeagueService();
  List<GameState> stateHistory = [];

  GameController() {
    defaultGameLogic.setStateContext(state);
  }

  void handleAction(Map<String, dynamic> action) {
    final gameLogic =
        state.gameType == '141' ? straightPoolGameLogic : poolGameLogic;
    // Set state context for game logic
    gameLogic.setStateContext(state);

    if (state.gameType == '141') {
      switch (action['type']) {
        case 'BALL_CLICK':
          // Save state for undo
          stateHistory.add(state.clone());

          // Handle ball click
          straightPoolGameLogic.handleBallClick(
            action['ballNumber'],
            action['isFoul'] ?? false,
          );

          // Check win condition
          if (straightPoolGameLogic.checkWinCondition(state.activePlayer)) {
            state.winner = state.activePlayer;
          }
          break;

        case 'RERACK':
          // Save state for undo
          stateHistory.add(state.clone());

          // Handle rerack
          straightPoolGameLogic.handleRerack();
          break;
      }
    } else {
      // Pool game actions
      switch (action['type']) {
        case 'SCORE':
          // Populate state history with unmodified state for undo
          stateHistory.add(state.clone());

          int player = action['player'];
          if (state.scores[player - 1] < state.raceToWin) {
            gameLogic.increaseScore(player);
            if (gameLogic.checkWinCondition(player)) {
              state.winner = player;
            }
          }
          break;
      }
    }

    // actions for pool and straight pool games
    switch (action['type']) {
      case 'UPDATE_NAME':
        state.playerNames[action['player'] - 1] = action['name'];
        break;

      case 'UNDO':
        if (stateHistory.isNotEmpty) {
          state = stateHistory.removeLast();
          gameLogic.setStateContext(state);
          print('Restored scores: ${state.scores}');
        }
        break;
    }

    notifyListeners();
  }

  bool canUndo() {
    return stateHistory.isNotEmpty;
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
      maxInnings: config['maxInnings'],
      ballsOnTable: 15,
      currentBreak: config['gameType'] == '141' ? 0 : null,
      consecutiveFouls: [0, 0],
      innings: [0, 0],
      highestBreaks: [0, 0],
      selectedAssociation: state.selectedAssociation,
      selectedLeagueId: state.selectedLeagueId,
      homeTeamId: state.homeTeamId,
      awayTeamId: state.awayTeamId,
    );

    stateHistory = [];
    notifyListeners();
  }

  Future<void> setAssociation(String association) async {
    state.selectedAssociation = association;
    state.selectedLeagueId = null;
    state.homeTeamId = null;
    state.awayTeamId = null;
    await leagueService.saveSelection(
      association: association,
      leagueId: '',
    );
    notifyListeners();
  }

  Future<void> setLeague(String leagueId) async {
    state.selectedLeagueId = leagueId;
    await leagueService.saveSelection(
      association: state.selectedAssociation!,
      leagueId: leagueId,
    );
    notifyListeners();
  }

  Future<void> setHomeTeam(String teamId) async {
    state.homeTeamId = teamId;
    await leagueService.saveSelection(
      association: state.selectedAssociation!,
      leagueId: state.selectedLeagueId!,
      homeTeamId: teamId,
    );
    notifyListeners();
  }

  Future<void> setAwayTeam(String teamId) async {
    state.awayTeamId = teamId;
    await leagueService.saveSelection(
      association: state.selectedAssociation!,
      leagueId: state.selectedLeagueId!,
      awayTeamId: teamId,
    );
    notifyListeners();
  }
}
