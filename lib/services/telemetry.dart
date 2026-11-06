import 'package:flutter/foundation.dart';

/// Telemetria minima dell'app.
abstract class AppTelemetry {
  const AppTelemetry();

  void track(String event, {Map<String, Object?> params = const {}});
}

class DebugPrintTelemetry extends AppTelemetry {
  const DebugPrintTelemetry();

  @override
  void track(String event, {Map<String, Object?> params = const {}}) {
    debugPrint('telemetry:$event params:$params');
  }
}
