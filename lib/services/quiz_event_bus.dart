import 'dart:async';

import '../models/leaderboard_entry.dart';
import '../models/score_update.dart';

class QuizEventBus {
  final StreamController<ScoreUpdate> _scoreController =
      StreamController<ScoreUpdate>.broadcast();
  final StreamController<List<LeaderboardEntry>> _leaderboardController =
      StreamController<List<LeaderboardEntry>>.broadcast();

  Stream<ScoreUpdate> get scoreUpdates => _scoreController.stream;
  Stream<List<LeaderboardEntry>> get leaderboardUpdates =>
      _leaderboardController.stream;

  void emitScoreUpdate(ScoreUpdate update) {
    _scoreController.add(update);
  }

  void emitLeaderboardUpdate(List<LeaderboardEntry> entries) {
    _leaderboardController.add(entries);
  }

  Future<void> dispose() async {
    await _scoreController.close();
    await _leaderboardController.close();
  }
}
