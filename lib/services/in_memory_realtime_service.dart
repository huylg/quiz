import 'dart:async';

import '../models/connection_status.dart';
import '../models/leaderboard_entry.dart';
import '../models/score_update.dart';
import 'quiz_event_bus.dart';
import 'realtime_service.dart';

class InMemoryRealtimeService implements RealtimeService {
  InMemoryRealtimeService({
    required QuizEventBus eventBus,
  }) : _eventBus = eventBus;

  final QuizEventBus _eventBus;
  final StreamController<ConnectionStatus> _statusController =
      StreamController<ConnectionStatus>.broadcast();
  ConnectionStatus _status = ConnectionStatus.disconnected;

  @override
  Stream<ConnectionStatus> get connectionStatus => _statusController.stream;

  @override
  Stream<ScoreUpdate> get scoreUpdates => _eventBus.scoreUpdates;

  @override
  Stream<List<LeaderboardEntry>> get leaderboardUpdates =>
      _eventBus.leaderboardUpdates;

  @override
  Future<void> connect({
    required String sessionId,
    required String playerId,
  }) async {
    _setStatus(ConnectionStatus.connected);
  }

  @override
  Future<void> disconnect() async {
    _setStatus(ConnectionStatus.disconnected);
  }

  void _setStatus(ConnectionStatus status) {
    _status = status;
    _statusController.add(_status);
  }

  Future<void> dispose() async {
    await _statusController.close();
  }
}
