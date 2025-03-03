// lib/services/league_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/league.dart';
import '../models/team.dart';

class LeagueService {
  // In-memory cache
  Map<String, List<League>>? _leagues;
  Map<String, List<Team>>? _teams;

  // Mock data - in a real app, you'd fetch this from an API
  final Map<String, List<Map<String, dynamic>>> _mockLeaguesData = {
    'DBU': [
      {
        'id': 'bundesliga',
        'name': 'Bundesliga',
        'targets': {
          '8ball': 8,
          '9ball': 9,
          '10ball': 6,
          '141': {'points': 100, 'innings': 30}
        }
      },
      {
        'id': '2bundesliga',
        'name': '2. Bundesliga',
        'targets': {
          '8ball': 7,
          '9ball': 8,
          '10ball': 5,
          '141': {'points': 90, 'innings': 25}
        }
      }
    ],
    'BLVN': [
      {
        'id': 'landesliga',
        'name': 'Landesliga',
        'targets': {
          '8ball': 6,
          '9ball': 7,
          '10ball': 4,
          '141': {'points': 75, 'innings': 20}
        }
      },
      {
        'id': 'verbandsliga',
        'name': 'Verbandsliga',
        'targets': {
          '8ball': 5,
          '9ball': 6,
          '10ball': 4,
          '141': {'points': 60, 'innings': 20}
        }
      }
    ]
  };

  final Map<String, List<Map<String, dynamic>>> _mockTeamsData = {
    'DBU': [
      {'id': 'team1', 'name': 'BSV München', 'logo': null},
      {'id': 'team2', 'name': 'PBC Berlin', 'logo': null},
    ],
    'BLVN': [
      {'id': 'team3', 'name': 'BG Hannover', 'logo': null},
      {'id': 'team4', 'name': 'BSG Osnabrück', 'logo': null},
    ]
  };

  // Load leagues data
  Future<Map<String, List<League>>> getLeagues() async {
    if (_leagues != null) {
      return _leagues!;
    }

    // In a real app, you'd fetch from an API or local storage
    // For now, we'll use mock data
    _leagues = {};
    _mockLeaguesData.forEach((association, leaguesList) {
      _leagues![association] = leaguesList
          .map((json) => League.fromJson(json, association))
          .toList();
    });

    return _leagues!;
  }

  // Load teams data
  Future<Map<String, List<Team>>> getTeams() async {
    if (_teams != null) {
      return _teams!;
    }

    // In a real app, you'd fetch from an API or local storage
    _teams = {};
    _mockTeamsData.forEach((association, teamsList) {
      _teams![association] =
          teamsList.map((json) => Team.fromJson(json, association)).toList();
    });

    return _teams!;
  }

  // Get targets for a specific league and game type
  Future<dynamic> getTargets(
      String association, String leagueId, String gameType) async {
    final leagues = await getLeagues();
    final league = leagues[association]?.firstWhere(
      (l) => l.id == leagueId,
      orElse: () => throw Exception('League not found'),
    );

    if (league == null) {
      return null;
    }

    return league.targets[gameType];
  }

  // Save selected league and teams to preferences
  Future<void> saveSelection({
    required String association,
    required String leagueId,
    String? homeTeamId,
    String? awayTeamId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_association', association);
    await prefs.setString('selected_league', leagueId);

    if (homeTeamId != null) {
      await prefs.setString('selected_home_team', homeTeamId);
    }

    if (awayTeamId != null) {
      await prefs.setString('selected_away_team', awayTeamId);
    }
  }

  // Get the saved selection
  Future<Map<String, String?>> getSelection() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'association': prefs.getString('selected_association'),
      'leagueId': prefs.getString('selected_league'),
      'homeTeamId': prefs.getString('selected_home_team'),
      'awayTeamId': prefs.getString('selected_away_team'),
    };
  }

  // Generate placeholder SVG for team logo
  String generatePlaceholderSvg(String initials) {
    // A simple SVG with the team's initials
    return '''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="#2196F3"/>
      <text x="50" y="50" font-family="Arial" font-size="30" fill="white" text-anchor="middle" dominant-baseline="middle">$initials</text>
    </svg>
    ''';
  }

  // Get team initials from name
  String getTeamInitials(String teamName) {
    final words = teamName.split(' ').where((word) => word.length > 1).toList();
    if (words.length < 2) return 'TL';
    final lastTwo = words.sublist(words.length - 2);
    return (lastTwo[0][0] + lastTwo[1][0]).toUpperCase();
  }

  // Get team logo (in a real app, this would fetch from a server)
  Future<String?> getTeamLogo(String teamId, String association) async {
    final teams = await getTeams();
    final team = teams[association]?.firstWhere(
      (t) => t.id == teamId,
      orElse: () => throw Exception('Team not found'),
    );

    if (team == null) {
      return null;
    }

    // If team has a logo, return it, otherwise generate placeholder
    return team.logo ?? generatePlaceholderSvg(getTeamInitials(team.name));
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_association');
    await prefs.remove('selected_league');
    await prefs.remove('selected_home_team');
    await prefs.remove('selected_away_team');
  }
}
