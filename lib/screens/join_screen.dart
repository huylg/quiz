import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/quiz_session.dart';
import '../services/quiz_service.dart';
import '../theme/app_theme.dart';
import '../viewmodels/join_view_model.dart';
import '../widgets/connection_status_banner.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key, required this.quizService});

  final QuizService quizService;

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  late final JoinViewModel _viewModel;
  final TextEditingController _quizIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = JoinViewModel(quizService: widget.quizService);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _quizIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return Scaffold(
      appBar: AppBar(title: const Text('Join Quiz')),
      body: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const ConnectionStatusBanner(
                  status: null,
                ),
                SizedBox(height: spacing.md),
                Semantics(
                  label: 'Quiz ID input',
                  child: TextField(
                    controller: _quizIdController,
                    decoration: const InputDecoration(
                      labelText: 'Quiz ID',
                      hintText: 'Enter quiz ID',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: spacing.md),
                Semantics(
                  label: 'Player name input',
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                SizedBox(height: spacing.lg),
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
                  label: 'Join quiz',
                  child: ElevatedButton(
                    onPressed: _viewModel.isLoading
                        ? null
                        : () => _handleJoin(context),
                    child: _viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Join Quiz'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleJoin(BuildContext context) async {
    final session = await _viewModel.join(
      sessionId: _quizIdController.text,
      playerName: _nameController.text,
    );
    if (session != null && context.mounted) {
      context.go('/gameplay', extra: session);
    }
  }
}
