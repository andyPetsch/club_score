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
  List<int> consecutiveFouls;
  List<int> innings;
  List<int> highestBreaks;
  String? selectedAssociation;
  String? selectedLeagueId;
  String? homeTeamId;
  String? awayTeamId;
  int ballsOnTable;
  int? currentBreak;
  int? maxInnings;

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
    this.selectedAssociation,
    this.selectedLeagueId,
    this.homeTeamId,
    this.awayTeamId,
    this.ballsOnTable = 15,
    this.currentBreak,
    this.maxInnings,
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
      selectedAssociation: selectedAssociation,
      selectedLeagueId: selectedLeagueId,
      homeTeamId: homeTeamId,
      awayTeamId: awayTeamId,
      ballsOnTable: ballsOnTable,
      currentBreak: currentBreak,
      maxInnings: maxInnings,
    );
  }
}
