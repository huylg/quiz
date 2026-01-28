import 'package:flutter/material.dart';

import '../models/connection_status.dart';
import '../theme/app_theme.dart';

class ConnectionStatusBanner extends StatelessWidget {
  const ConnectionStatusBanner({super.key, required this.status});

  final ConnectionStatus? status;

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return const SizedBox.shrink();
    }
    final colors = Theme.of(context).extension<AppColors>()!;
    late final Color background;
    late final String label;
    switch (status!) {
      case ConnectionStatus.connected:
        background = colors.success;
        label = 'Connected';
      case ConnectionStatus.reconnecting:
        background = colors.warning;
        label = 'Reconnecting...';
      case ConnectionStatus.disconnected:
        background = colors.error;
        label = 'Disconnected';
    }
    return Semantics(
      liveRegion: true,
      label: 'Connection status: $label',
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
