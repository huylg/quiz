import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/quiz_session.dart';
import '../services/quiz_service.dart';
import '../services/realtime_service.dart';
import '../theme/app_theme.dart';
import '../viewmodels/gameplay_view_model.dart';
import '../widgets/answer_option_tile.dart';
import '../widgets/connection_status_banner.dart';
import '../widgets/score_badge.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({
    super.key,
    required this.session,
    required this.quizService,
    required this.realtimeService,
  });

  final QuizSession session;
  final QuizService quizService;
  final RealtimeService realtimeService;

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late final GameplayViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GameplayViewModel(
      quizService: widget.quizService,
      realtimeService: widget.realtimeService,
    );
    _viewModel.start(widget.session);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gameplay'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.go('/leaderboard', extra: widget.session);
            },
            icon: const Icon(Icons.leaderboard),
            tooltip: 'View leaderboard',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            final question = _viewModel.question;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ConnectionStatusBanner(status: _viewModel.connectionStatus),
                SizedBox(height: spacing.md),
                ScoreBadge(score: _viewModel.score),
                SizedBox(height: spacing.md),
                if (question == null)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          question.text,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: spacing.md),
                        Expanded(
                          child: ListView.builder(
                            itemCount: question.answers.length,
                            itemBuilder: (context, index) {
                              final answer = question.answers[index];
                              return AnswerOptionTile(
                                answer: answer,
                                isSelected: _viewModel.selectedAnswerId ==
                                    answer.id,
                                onSelected: _viewModel.isSubmitting
                                    ? null
                                    : () => _viewModel.selectAnswer(answer.id),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: spacing.md),
                        if (_viewModel.errorMessage != null)
                          Text(
                            _viewModel.errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .error,
                            ),
                          ),
                        SizedBox(height: spacing.md),
                        Semantics(
                          button: true,
                          label: 'Submit answer',
                          child: ElevatedButton(
                            onPressed: _viewModel.isSubmitting ||
                                    _viewModel.selectedAnswerId == null
                                ? null
                                : _viewModel.submitAnswer,
                            child: _viewModel.isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Submit Answer'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
