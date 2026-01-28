import '../models/answer_option.dart';
import '../models/leaderboard_entry.dart';
import '../models/player.dart';
import '../models/question.dart';
import '../models/quiz_session.dart';
import '../models/score_update.dart';

class InMemoryQuizRepository {
  final Map<String, _SessionState> _sessions = <String, _SessionState>{};

  QuizSession join({
    required String sessionId,
    required String playerName,
  }) {
    final session = _sessions.putIfAbsent(
      sessionId,
      () => _SessionState.sample(sessionId),
    );
    final playerId = session.registerPlayer(playerName);
    return QuizSession(
      sessionId: sessionId,
      playerId: playerId,
      playerName: playerName,
      status: session.status,
    );
  }

  Question currentQuestion({required String sessionId}) {
    final session = _sessions[sessionId];
    if (session == null) {
      throw StateError('Session not found.');
    }
    return session.currentQuestion;
  }

  ScoreUpdate submitAnswer({
    required String sessionId,
    required String playerId,
    required String questionId,
    required String answerId,
  }) {
    final session = _sessions[sessionId];
    if (session == null) {
      throw StateError('Session not found.');
    }
    return session.submitAnswer(
      playerId: playerId,
      questionId: questionId,
      answerId: answerId,
    );
  }

  List<LeaderboardEntry> leaderboard({required String sessionId}) {
    final session = _sessions[sessionId];
    if (session == null) {
      throw StateError('Session not found.');
    }
    return session.leaderboardEntries;
  }
}

class _SessionState {
  _SessionState({
    required this.sessionId,
    required this.questions,
    required this.status,
  });

  final String sessionId;
  final List<Question> questions;
  String status;
  int _currentQuestionIndex = 0;
  final Map<String, Player> _players = <String, Player>{};

  static _SessionState sample(String sessionId) {
    return _SessionState(
      sessionId: sessionId,
      status: 'active',
      questions: <Question>[
        Question(
          id: 'q1',
          text: 'What is 2 + 2?',
          answers: const <AnswerOption>[
            AnswerOption(id: 'a1', text: '3'),
            AnswerOption(id: 'a2', text: '4'),
            AnswerOption(id: 'a3', text: '5'),
          ],
          correctAnswerId: 'a2',
          points: 10,
        ),
        Question(
          id: 'q2',
          text: 'Which planet is known as the Red Planet?',
          answers: const <AnswerOption>[
            AnswerOption(id: 'a1', text: 'Mars'),
            AnswerOption(id: 'a2', text: 'Venus'),
            AnswerOption(id: 'a3', text: 'Jupiter'),
          ],
          correctAnswerId: 'a1',
          points: 10,
        ),
      ],
    );
  }

  String registerPlayer(String name) {
    final playerId = 'p${_players.length + 1}';
    _players[playerId] = Player(id: playerId, name: name, score: 0);
    return playerId;
  }

  Question get currentQuestion => questions[_currentQuestionIndex];

  ScoreUpdate submitAnswer({
    required String playerId,
    required String questionId,
    required String answerId,
  }) {
    if (!_players.containsKey(playerId)) {
      throw StateError('Player not found.');
    }
    final question = questions.firstWhere(
      (item) => item.id == questionId,
      orElse: () => currentQuestion,
    );
    final isCorrect = question.correctAnswerId == answerId;
    final player = _players[playerId]!;
    final nextScore = player.score + (isCorrect ? question.points : 0);
    _players[playerId] = player.copyWith(score: nextScore);
    _advanceQuestion();
    return ScoreUpdate(playerId: playerId, score: nextScore);
  }

  List<LeaderboardEntry> get leaderboardEntries {
    final entries = _players.values.toList()
      ..sort((a, b) {
        final scoreOrder = b.score.compareTo(a.score);
        if (scoreOrder != 0) {
          return scoreOrder;
        }
        return a.name.compareTo(b.name);
      });
    return List<LeaderboardEntry>.generate(entries.length, (index) {
      final player = entries[index];
      return LeaderboardEntry(
        playerId: player.id,
        playerName: player.name,
        score: player.score,
        rank: index + 1,
      );
    });
  }

  void _advanceQuestion() {
    _currentQuestionIndex =
        (_currentQuestionIndex + 1) % questions.length;
  }
}
