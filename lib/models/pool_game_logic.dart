// lib/models/pool_game_logic.dart
import 'game_state.dart';

class PoolGameLogic {
  late GameState state;

  void setStateContext(GameState state) {
    this.state = state;
  }

  void increaseScore(int player) {
    state.scores[player - 1]++;
    updateBreakingPlayer(player);
  }

  void updateBreakingPlayer(int scoringPlayer) {
    if (state.breakType == 'winner') {
      state.breakingPlayer = scoringPlayer;
    } else if (state.breakType == 'alternating') {
      state.breakingPlayer = state.breakingPlayer == 1 ? 2 : 1;
    }
  }

  bool checkWinCondition(int player) {
    return state.scores[player - 1] == state.raceToWin;
  }
}
