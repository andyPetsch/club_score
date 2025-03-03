// lib/models/team.dart
class Team {
  final String id;
  final String name;
  final String? logo;
  final String association;

  Team({
    required this.id,
    required this.name,
    this.logo,
    required this.association,
  });

  factory Team.fromJson(Map<String, dynamic> json, String association) {
    return Team(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      association: association,
    );
  }
}
