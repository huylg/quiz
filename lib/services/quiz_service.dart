import '../models/question.dart';
import '../models/quiz_session.dart';

abstract class QuizService {
  Future<QuizSession> joinSession({
    required String sessionId,
    required String playerName,
  });

  Future<Question> fetchCurrentQuestion({
    required String sessionId,
  });

  Future<void> submitAnswer({
    required String sessionId,
    required String playerId,
    required String questionId,
    required String answerId,
  });
}
