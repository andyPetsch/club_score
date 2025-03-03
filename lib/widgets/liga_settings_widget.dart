// lib/widgets/liga_settings_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/league.dart';
import '../models/team.dart';
import '../services/league_service.dart';

class LigaSettingsWidget extends StatefulWidget {
  final Function(bool)? onLigaModeChanged;

  const LigaSettingsWidget({Key? key, this.onLigaModeChanged})
      : super(key: key);

  @override
  _LigaSettingsWidgetState createState() => _LigaSettingsWidgetState();
}

class _LigaSettingsWidgetState extends State<LigaSettingsWidget> {
  bool _ligaModeEnabled = false;
  String? _selectedAssociation;
  String? _selectedLeagueId;
  String? _selectedHomeTeamId;
  String? _selectedAwayTeamId;
  Map<String, List<League>> _leagues = {};
  Map<String, List<Team>> _teams = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final gameController = Provider.of<GameController>(context, listen: false);

    // Load leagues and teams
    _leagues = await gameController.leagueService.getLeagues();
    _teams = await gameController.leagueService.getTeams();

    // Load saved selections
    final selection = await gameController.leagueService.getSelection();

    setState(() {
      _selectedAssociation = selection['association'];
      _selectedLeagueId = selection['leagueId'];
      _selectedHomeTeamId = selection['homeTeamId'];
      _selectedAwayTeamId = selection['awayTeamId'];
      _ligaModeEnabled =
          _selectedAssociation != null && _selectedLeagueId != null;
      _isLoading = false;

      if (_ligaModeEnabled && widget.onLigaModeChanged != null) {
        widget.onLigaModeChanged!(_ligaModeEnabled);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Liga-Mode toggle
        SwitchListTile(
          title: const Text('Liga-Modus aktivieren'),
          value: _ligaModeEnabled,
          onChanged: (value) {
            setState(() {
              _ligaModeEnabled = value;
            });
            if (widget.onLigaModeChanged != null) {
              widget.onLigaModeChanged!(value);
            }
          },
        ),

        if (_ligaModeEnabled) ...[
          const SizedBox(height: 16),

          // Association selection
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Verband',
              border: OutlineInputBorder(),
            ),
            value: _selectedAssociation,
            items: _leagues.keys.map((association) {
              return DropdownMenuItem<String>(
                value: association,
                child: Text(association),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedAssociation = value;
                  _selectedLeagueId = null;
                  _selectedHomeTeamId = null;
                  _selectedAwayTeamId = null;
                });
                gameController.setAssociation(value);
              }
            },
          ),

          const SizedBox(height: 16),

          // League selection (only if association is selected)
          if (_selectedAssociation != null) ...[
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Liga',
                border: OutlineInputBorder(),
              ),
              value: _selectedLeagueId,
              items: _leagues[_selectedAssociation]?.map((league) {
                    return DropdownMenuItem<String>(
                      value: league.id,
                      child: Text(league.name),
                    );
                  }).toList() ??
                  [],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLeagueId = value;
                  });
                  gameController.setLeague(value);
                }
              },
            ),
            const SizedBox(height: 16),
          ],

          // Team selection (only if league is selected)
          if (_selectedAssociation != null && _selectedLeagueId != null) ...[
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Heimmannschaft',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedHomeTeamId,
                    items: _teams[_selectedAssociation]?.map((team) {
                          return DropdownMenuItem<String>(
                            value: team.id,
                            child: Text(team.name),
                          );
                        }).toList() ??
                        [],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedHomeTeamId = value;
                        });
                        gameController.setHomeTeam(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Gastmannschaft',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedAwayTeamId,
                    items: _teams[_selectedAssociation]?.map((team) {
                          return DropdownMenuItem<String>(
                            value: team.id,
                            child: Text(team.name),
                          );
                        }).toList() ??
                        [],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedAwayTeamId = value;
                        });
                        gameController.setAwayTeam(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }
}
