// lib/models/straight_pool_game_logic.dart
import 'game_state.dart';
import 'game_logic.dart';

class StraightPoolGameLogic implements GameLogic {
  late GameState state;

  void setStateContext(GameState state) {
    this.state = state;
  }

  void increaseScore(int player) {
    // only for compatibility with game controller
    // score increases only via handleBallClick
  }

  void handleBallClick(int clickedBallNumber, bool isFoul) {
    // Calculate points based on remaining balls
    final pointsToAward = state.ballsOnTable - clickedBallNumber;
    final playerIndex = state.activePlayer - 1;

    // If points are scored, reset consecutive fouls
    if (pointsToAward > 0) {
      state.consecutiveFouls[playerIndex] = 0;
    }

    // Handle foul if in foul mode
    if (isFoul) {
      handleFoul(false);
    } else {
      state.consecutiveFouls[playerIndex] = 0;
    }

    // Award points
    state.scores[playerIndex] += pointsToAward;
    state.currentBreak = (state.currentBreak ?? 0) + pointsToAward;

    // Update balls on table
    state.ballsOnTable = clickedBallNumber;

    // Update highest break if current break is higher
    updateHighBreak();

    // Switch to the other player
    switchActivePlayer();
  }

  void handleFoul(bool isBreakFoul) {
    final playerIndex = state.activePlayer - 1;
    state.consecutiveFouls[playerIndex]++;

    // Calculate penalty based on consecutive fouls
    int foulPenalty = isBreakFoul ? 2 : 1;
    if (state.consecutiveFouls[playerIndex] >= 3) {
      foulPenalty = 15;
      state.consecutiveFouls[playerIndex] = 0;
    }

    // Apply penalty
    state.scores[playerIndex] -= foulPenalty;
    state.currentBreak = (state.currentBreak ?? 0) - foulPenalty;

    // Ensure score doesn't go below zero
    if (state.scores[playerIndex] < 0) {
      state.scores[playerIndex] = 0;
    }
    if (state.currentBreak! < 0) {
      state.currentBreak = 0;
    }
  }

  void handleRerack() {
    // Award points for the balls left on the table (excluding the white ball)
    final pointsToAdd = state.ballsOnTable - 1;
    final playerIndex = state.activePlayer - 1;

    state.scores[playerIndex] += pointsToAdd;
    state.currentBreak = (state.currentBreak ?? 0) + pointsToAdd;

    // Reset to 15 balls after rerack
    state.ballsOnTable = 15;

    // Update highest break
    updateHighBreak();
  }

  void updateHighBreak() {
    final playerIndex = state.activePlayer - 1;
    if (state.currentBreak! > state.highestBreaks[playerIndex]) {
      state.highestBreaks[playerIndex] = state.currentBreak!;
    }
  }

  void switchActivePlayer() {
    final currentPlayerIndex = state.activePlayer - 1;

    // Increment innings for the current player
    state.innings[currentPlayerIndex]++;

    // Switch active player
    state.activePlayer = state.activePlayer == 1 ? 2 : 1;

    // Reset current break for the new player
    state.currentBreak = 0;
  }

  bool checkWinCondition(int player) {
    final playerIndex = player - 1;

    // Check if player has reached target score
    if (state.scores[playerIndex] >= state.raceToWin) {
      return true;
    }

    // Check innings limit if specified
    if (state.maxInnings != null &&
        state.innings[0] >= state.maxInnings! &&
        state.innings[1] >= state.maxInnings!) {
      // If both players reached the innings limit, the player with the highest score wins
      final otherPlayerIndex = playerIndex == 0 ? 1 : 0;
      return state.scores[playerIndex] > state.scores[otherPlayerIndex];
    }

    return false;
  }
}
