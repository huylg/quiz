import 'package:flutter/foundation.dart';

import '../models/quiz_session.dart';
import '../services/quiz_service.dart';

class JoinViewModel extends ChangeNotifier {
  JoinViewModel({required QuizService quizService})
      : _quizService = quizService;

  final QuizService _quizService;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<QuizSession?> join({
    required String sessionId,
    required String playerName,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    notifyListeners();
    try {
      final session = await _quizService.joinSession(
        sessionId: sessionId,
        playerName: playerName,
      );
      return session;
    } catch (error) {
      _errorMessage = error.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
