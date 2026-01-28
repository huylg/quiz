import 'package:flutter/material.dart';

import '../models/quiz_session.dart';
import '../services/realtime_service.dart';
import '../theme/app_theme.dart';
import '../viewmodels/leaderboard_view_model.dart';
import '../widgets/connection_status_banner.dart';
import '../widgets/leaderboard_row.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({
    super.key,
    required this.session,
    required this.realtimeService,
  });

  final QuizSession session;
  final RealtimeService realtimeService;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late final LeaderboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LeaderboardViewModel(
      realtimeService: widget.realtimeService,
    );
    _viewModel.start(
      sessionId: widget.session.sessionId,
      playerId: widget.session.playerId,
    );
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
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            final entries = _viewModel.entries;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ConnectionStatusBanner(
                  status: _viewModel.connectionStatus,
                ),
                SizedBox(height: spacing.md),
                if (entries.isEmpty)
                  const Center(child: Text('No players yet.'))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final isSelf = entry.playerId ==
                            widget.session.playerId;
                        return LeaderboardRow(
                          entry: entry,
                          highlight: isSelf,
                        );
                      },
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
