import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/connection_status.dart';
import '../models/leaderboard_entry.dart';
import '../services/realtime_service.dart';

class LeaderboardViewModel extends ChangeNotifier {
  LeaderboardViewModel({required RealtimeService realtimeService})
      : _realtimeService = realtimeService;

  final RealtimeService _realtimeService;

  List<LeaderboardEntry> _entries = <LeaderboardEntry>[];
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  StreamSubscription<List<LeaderboardEntry>>? _leaderboardSubscription;
  StreamSubscription<ConnectionStatus>? _statusSubscription;

  List<LeaderboardEntry> get entries => _entries;
  ConnectionStatus get connectionStatus => _connectionStatus;

  Future<void> start({
    required String sessionId,
    required String playerId,
  }) async {
    await _realtimeService.connect(
      sessionId: sessionId,
      playerId: playerId,
    );
    _statusSubscription =
        _realtimeService.connectionStatus.listen(_handleStatus);
    _leaderboardSubscription =
        _realtimeService.leaderboardUpdates.listen(_handleLeaderboard);
  }

  void _handleLeaderboard(List<LeaderboardEntry> entries) {
    _entries = entries;
    notifyListeners();
  }

  void _handleStatus(ConnectionStatus status) {
    _connectionStatus = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _leaderboardSubscription?.cancel();
    _statusSubscription?.cancel();
    _realtimeService.disconnect();
    super.dispose();
  }
}
