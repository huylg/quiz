import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/connection_status.dart';
import '../models/question.dart';
import '../models/quiz_session.dart';
import '../models/score_update.dart';
import '../services/quiz_service.dart';
import '../services/realtime_service.dart';

class GameplayViewModel extends ChangeNotifier {
  GameplayViewModel({
    required QuizService quizService,
    required RealtimeService realtimeService,
  })  : _quizService = quizService,
        _realtimeService = realtimeService;

  final QuizService _quizService;
  final RealtimeService _realtimeService;

  QuizSession? _session;
  Question? _question;
  String? _selectedAnswerId;
  bool _isSubmitting = false;
  int _score = 0;
  String? _errorMessage;
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  StreamSubscription<ScoreUpdate>? _scoreSubscription;
  StreamSubscription<ConnectionStatus>? _statusSubscription;

  Question? get question => _question;
  String? get selectedAnswerId => _selectedAnswerId;
  bool get isSubmitting => _isSubmitting;
  int get score => _score;
  String? get errorMessage => _errorMessage;
  ConnectionStatus get connectionStatus => _connectionStatus;

  Future<void> start(QuizSession session) async {
    _session = session;
    await _realtimeService.connect(
      sessionId: session.sessionId,
      playerId: session.playerId,
    );
    _statusSubscription =
        _realtimeService.connectionStatus.listen(_handleStatus);
    _scoreSubscription = _realtimeService.scoreUpdates.listen(_handleScore);
    await _loadQuestion();
  }

  Future<void> submitAnswer() async {
    final session = _session;
    final question = _question;
    final answerId = _selectedAnswerId;
    if (session == null || question == null || answerId == null) {
      return;
    }
    _setSubmitting(true);
    _errorMessage = null;
    notifyListeners();
    try {
      await _quizService.submitAnswer(
        sessionId: session.sessionId,
        playerId: session.playerId,
        questionId: question.id,
        answerId: answerId,
      );
      _selectedAnswerId = null;
      await _loadQuestion();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _setSubmitting(false);
    }
  }

  void selectAnswer(String answerId) {
    _selectedAnswerId = answerId;
    notifyListeners();
  }

  void _handleScore(ScoreUpdate update) {
    final session = _session;
    if (session == null || update.playerId != session.playerId) {
      return;
    }
    _score = update.score;
    notifyListeners();
  }

  void _handleStatus(ConnectionStatus status) {
    _connectionStatus = status;
    notifyListeners();
  }

  Future<void> _loadQuestion() async {
    final session = _session;
    if (session == null) {
      return;
    }
    _question = await _quizService.fetchCurrentQuestion(
      sessionId: session.sessionId,
    );
    notifyListeners();
  }

  void _setSubmitting(bool value) {
    _isSubmitting = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _scoreSubscription?.cancel();
    _statusSubscription?.cancel();
    _realtimeService.disconnect();
    super.dispose();
  }
}
