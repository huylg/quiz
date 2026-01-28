import 'package:flutter/material.dart';

import '../models/leaderboard_entry.dart';
import '../theme/app_theme.dart';

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({
    super.key,
    required this.entry,
    required this.highlight,
  });

  final LeaderboardEntry entry;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Semantics(
      label: 'Rank ${entry.rank}, ${entry.playerName}, '
          'score ${entry.score}',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: highlight ? colors.primary.withOpacity(0.1) : colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: highlight ? colors.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              child: Text('${entry.rank}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entry.playerName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text('${entry.score}'),
          ],
        ),
      ),
    );
  }
}
