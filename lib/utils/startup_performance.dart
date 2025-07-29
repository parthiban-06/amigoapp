import 'package:visaamigo/utils/utils.dart';

/// Utility class to monitor app startup performance
class StartupPerformance {
  static final Map<String, DateTime> _timestamps = {};
  static final Map<String, Duration> _durations = {};

  /// Mark a startup milestone
  static void markMilestone(String milestone) {
    _timestamps[milestone] = DateTime.now();
    Utils.logPrint('⏱️ Startup milestone: $milestone');
  }

  /// Calculate duration between two milestones
  static Duration? getDuration(String startMilestone, String endMilestone) {
    final start = _timestamps[startMilestone];
    final end = _timestamps[endMilestone];

    if (start != null && end != null) {
      final duration = end.difference(start);
      _durations['${startMilestone}_to_${endMilestone}'] = duration;
      return duration;
    }
    return null;
  }

  /// Log all startup durations
  static void logStartupSummary() {
    Utils.logPrint('🚀 === STARTUP PERFORMANCE SUMMARY ===');

    _durations.forEach((key, duration) {
      Utils.logPrint('⏱️ $key: ${duration.inMilliseconds}ms');
    });

    // Calculate total startup time
    final firstMilestone = _timestamps.keys.first;
    final lastMilestone = _timestamps.keys.last;
    final totalDuration = getDuration(firstMilestone, lastMilestone);

    if (totalDuration != null) {
      Utils.logPrint(
          '⏱️ Total startup time: ${totalDuration.inMilliseconds}ms');
    }

    Utils.logPrint('🚀 === END STARTUP SUMMARY ===');
  }

  /// Check if startup is taking too long
  static bool isStartupSlow() {
    final totalDuration = _durations.values.fold<Duration>(
      Duration.zero,
      (total, duration) => total + duration,
    );

    // Consider startup slow if it takes more than 3 seconds
    return totalDuration.inMilliseconds > 3000;
  }

  /// Get startup performance data for analytics
  static Map<String, dynamic> getStartupMetrics() {
    return {
      'total_duration_ms': _durations.values.fold<int>(
        0,
        (total, duration) => total + duration.inMilliseconds,
      ),
      'milestone_count': _timestamps.length,
      'is_slow_startup': isStartupSlow(),
      'durations': _durations.map(
        (key, value) => MapEntry(key, value.inMilliseconds),
      ),
    };
  }

  /// Clear all performance data
  static void clear() {
    _timestamps.clear();
    _durations.clear();
  }
}
