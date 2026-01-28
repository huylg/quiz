class LeaderboardEntry {
  const LeaderboardEntry({
    required this.playerId,
    required this.playerName,
    required this.score,
    required this.rank,
  });

  final String playerId;
  final String playerName;
  final int score;
  final int rank;
}
