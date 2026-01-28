import '../models/question.dart';
import '../models/quiz_session.dart';
import '../logging/app_logger.dart';
import 'in_memory_quiz_repository.dart';
import 'quiz_event_bus.dart';
import 'quiz_service.dart';

class InMemoryQuizService implements QuizService {
  InMemoryQuizService({
    required InMemoryQuizRepository repository,
    required QuizEventBus eventBus,
  })  : _repository = repository,
        _eventBus = eventBus;

  final InMemoryQuizRepository _repository;
  final QuizEventBus _eventBus;
  final _logger = createLogger('QuizService');

  @override
  Future<QuizSession> joinSession({
    required String sessionId,
    required String playerName,
  }) async {
    if (sessionId.trim().isEmpty) {
      throw ArgumentError('Quiz ID is required.');
    }
    _logger.info('Join session $sessionId');
    return _repository.join(
      sessionId: sessionId.trim(),
      playerName: playerName.trim().isEmpty ? 'Player' : playerName.trim(),
    );
  }

  @override
  Future<Question> fetchCurrentQuestion({
    required String sessionId,
  }) async {
    return _repository.currentQuestion(sessionId: sessionId);
  }

  @override
  Future<void> submitAnswer({
    required String sessionId,
    required String playerId,
    required String questionId,
    required String answerId,
  }) async {
    final update = _repository.submitAnswer(
      sessionId: sessionId,
      playerId: playerId,
      questionId: questionId,
      answerId: answerId,
    );
    _logger.info('Answer submitted for $questionId');
    _eventBus.emitScoreUpdate(update);
    _eventBus.emitLeaderboardUpdate(
      _repository.leaderboard(sessionId: sessionId),
    );
  }
}
