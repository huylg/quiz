import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes/app_router.dart';
import 'services/in_memory_quiz_repository.dart';
import 'services/in_memory_quiz_service.dart';
import 'services/in_memory_realtime_service.dart';
import 'services/quiz_event_bus.dart';
import 'theme/app_theme.dart';

void main() {
  final repository = InMemoryQuizRepository();
  final eventBus = QuizEventBus();
  final quizService = InMemoryQuizService(
    repository: repository,
    eventBus: eventBus,
  );
  final realtimeService = InMemoryRealtimeService(
    eventBus: eventBus,
  );
  final router = buildRouter(
    quizService: quizService,
    realtimeService: realtimeService,
  );

  runApp(QuizApp(router: router));
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quiz',
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}
