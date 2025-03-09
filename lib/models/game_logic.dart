// lib/models/game_logic.dart
import 'game_state.dart';

abstract class GameLogic {
  void setStateContext(GameState state);
  bool checkWinCondition(int player);
  void increaseScore(int player);
}
