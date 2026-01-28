class Player {
  const Player({
    required this.id,
    required this.name,
    required this.score,
  });

  final String id;
  final String name;
  final int score;

  Player copyWith({int? score}) {
    return Player(
      id: id,
      name: name,
      score: score ?? this.score,
    );
  }
}
