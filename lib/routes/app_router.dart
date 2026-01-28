import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/quiz_session.dart';
import '../screens/gameplay_screen.dart';
import '../screens/join_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../services/quiz_service.dart';
import '../services/realtime_service.dart';

GoRouter buildRouter({
  required QuizService quizService,
  required RealtimeService realtimeService,
}) {
  return GoRouter(
    initialLocation: '/join',
    routes: <RouteBase>[
      GoRoute(
        path: '/join',
        builder: (context, state) => JoinScreen(
          quizService: quizService,
        ),
      ),
      GoRoute(
        path: '/gameplay',
        builder: (context, state) {
          final session = state.extra as QuizSession?;
          if (session == null) {
            return const JoinRedirectScreen();
          }
          return GameplayScreen(
            session: session,
            quizService: quizService,
            realtimeService: realtimeService,
          );
        },
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) {
          final session = state.extra as QuizSession?;
          if (session == null) {
            return const JoinRedirectScreen();
          }
          return LeaderboardScreen(
            session: session,
            realtimeService: realtimeService,
          );
        },
      ),
    ],
  );
}

class JoinRedirectScreen extends StatelessWidget {
  const JoinRedirectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.go('/join');
      }
    });
    return const Scaffold(
      body: Center(
        child: Text('Redirecting to join...'),
      ),
    );
  }
}
