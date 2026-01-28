class QuizSession {
  const QuizSession({
    required this.sessionId,
    required this.playerId,
    required this.playerName,
    required this.status,
  });

  final String sessionId;
  final String playerId;
  final String playerName;
  final String status;
}
