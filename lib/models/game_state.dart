// lib/models/game_state.dart
class GameState {
  List<String> playerNames;
  List<int> scores;
  String breakType;
  int breakingPlayer;
  int? winner;
  int activePlayer;
  String gameType;
  int raceToWin;
  List<int> consecutiveFouls; // Track fouls for each player
  List<int> innings; // Track innings for each player
  List<int> highestBreaks; // Track highest breaks for each player

  GameState({
    required this.playerNames,
    required this.scores,
    required this.breakType,
    required this.breakingPlayer,
    this.winner,
    required this.activePlayer,
    required this.gameType,
    required this.raceToWin,
    this.consecutiveFouls = const [0, 0],
    this.innings = const [0, 0],
    this.highestBreaks = const [0, 0],
  });

  // Create a default state
  factory GameState.defaultState() {
    return GameState(
      playerNames: ['Spieler 1', 'Spieler 2'],
      scores: [0, 0],
      breakType: 'alternating',
      breakingPlayer: 1,
      winner: null,
      activePlayer: 1,
      gameType: '9ball',
      raceToWin: 5,
    );
  }

  // Clone method for state updates
  GameState clone() {
    return GameState(
      playerNames: List.from(playerNames),
      scores: List.from(scores),
      breakType: breakType,
      breakingPlayer: breakingPlayer,
      winner: winner,
      activePlayer: activePlayer,
      gameType: gameType,
      raceToWin: raceToWin,
      consecutiveFouls: List.from(consecutiveFouls),
      innings: List.from(innings),
      highestBreaks: List.from(highestBreaks),
    );
  }
}
