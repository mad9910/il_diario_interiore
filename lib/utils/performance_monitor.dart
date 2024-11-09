import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class PerformanceMonitor {
  static void startMonitoring() {
    if (kDebugMode) {
      debugPrintRebuildDirtyWidgets = true;
      debugPrintLayouts = true;
      debugPrintBeginFrameBanner = true;
      debugPrintEndFrameBanner = true;
      debugPrintScheduleFrameStacks = true;
    }
  }

  static void logEvent(String event, {Map<String, dynamic>? parameters}) {
    if (kDebugMode) {
      print('Performance Event: $event');
      if (parameters != null) {
        parameters.forEach((key, value) {
          print('  $key: $value');
        });
      }
    }
  }
}
