// lib/models/league.dart
class League {
  final String id;
  final String name;
  final Map<String, dynamic> targets;
  final String association;

  League({
    required this.id,
    required this.name,
    required this.targets,
    required this.association,
  });

  factory League.fromJson(Map<String, dynamic> json, String association) {
    return League(
      id: json['id'],
      name: json['name'],
      targets: json['targets'],
      association: association,
    );
  }
}
