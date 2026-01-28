import '../models/connection_status.dart';
import '../models/leaderboard_entry.dart';
import '../models/score_update.dart';

abstract class RealtimeService {
  Stream<ConnectionStatus> get connectionStatus;
  Stream<ScoreUpdate> get scoreUpdates;
  Stream<List<LeaderboardEntry>> get leaderboardUpdates;

  Future<void> connect({
    required String sessionId,
    required String playerId,
  });

  Future<void> disconnect();
}
