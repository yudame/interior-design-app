import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  AppLogger._();

  static LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  static void debug(String message, {String? tag, Object? error}) {
    _log(LogLevel.debug, message, tag: tag, error: error);
  }

  static void info(String message, {String? tag, Object? error}) {
    _log(LogLevel.info, message, tag: tag, error: error);
  }

  static void warning(String message, {String? tag, Object? error}) {
    _log(LogLevel.warning, message, tag: tag, error: error);
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minLevel.index) return;

    final prefix = switch (level) {
      LogLevel.debug => '[DEBUG]',
      LogLevel.info => '[INFO]',
      LogLevel.warning => '[WARN]',
      LogLevel.error => '[ERROR]',
    };

    final tagPrefix = tag != null ? '[$tag] ' : '';
    final fullMessage = '$prefix $tagPrefix$message';

    if (kDebugMode) {
      developer.log(
        fullMessage,
        error: error,
        stackTrace: stackTrace,
        name: 'InteriorDesignApp',
      );
    }

    // In production, errors could be sent to Sentry
    if (level == LogLevel.error && !kDebugMode) {
      // TODO: Send to Sentry
    }
  }
}
