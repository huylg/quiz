import 'answer_option.dart';

class Question {
  const Question({
    required this.id,
    required this.text,
    required this.answers,
    required this.correctAnswerId,
    required this.points,
  });

  final String id;
  final String text;
  final List<AnswerOption> answers;
  final String correctAnswerId;
  final int points;
}
