import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

Logger createLogger(String name) {
  final logger = Logger(name);
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name} ${record.time.toIso8601String()} '
      '${record.loggerName} ${record.message}',
    );
  });
  return logger;
}
