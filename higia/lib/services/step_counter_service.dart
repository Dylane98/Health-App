import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';

/// StepCounterService
/// - encapsulates permission checks, native sensor detection, subscription to
///   the pedometer plugin and a safe simulator fallback.
/// - exposes two streams: cumulative steps (int) and errors (String).
class StepCounterService {
  final _stepsController = StreamController<int>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  Stream<int> get stepsStream => _stepsController.stream;
  Stream<String> get errorStream => _errorController.stream;

  StreamSubscription<StepCount>? _nativeSub;
  Timer? _simTimer;
  Timer? _sensorTimeout;

  int _simulatedSteps = 0;
  bool _running = false;

  static const _channel = MethodChannel('higia/native');

  /// Check whether the device has a native step counter (Android only).
  Future<bool> hasNativeSensor() async {
    if (!Platform.isAndroid) return true; // assume iOS will be handled by the plugin
    try {
      final bool result = await _channel.invokeMethod('hasStepCounter');
      return result;
    } catch (e) {
      // if native call fails, be tolerant and return true to let plugin decide
      return true;
    }
  }

  /// Request runtime permission for ACTIVITY_RECOGNITION (Android only).
  Future<bool> ensurePermission() async {
    try {
      if (!Platform.isAndroid) return true;
      final status = await Permission.activityRecognition.status;
      if (status.isGranted) return true;
      if (status.isPermanentlyDenied) return false;
      final result = await Permission.activityRecognition.request();
      return result.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Start the service: try sensor first (with permission and native check),
  /// otherwise start the simulator.
  Future<void> start() async {
    if (_running) return;
    _running = true;

    final allowed = await ensurePermission();
    if (!allowed) {
      _errorController.add('Permission not granted');
      _startSimulator();
      return;
    }

    final hasSensor = await hasNativeSensor();
    if (!hasSensor) {
      _errorController.add('Device has no step counter sensor');
      _startSimulator();
      return;
    }

    // subscribe to native pedometer
    try {
      _nativeSub?.cancel();
      _nativeSub = Pedometer.stepCountStream.listen((event) {
        // forward cumulative steps
        _stepsController.add(event.steps);
      }, onError: (err) {
        _errorController.add(err?.toString() ?? 'Pedometer stream error');
        _fallbackToSimulator('Pedometer stream error: $err');
      });

      // if we don't get a step event within timeout, fallback
      _sensorTimeout?.cancel();
      _sensorTimeout = Timer(const Duration(seconds: 5), () {
        // sensor didn't deliver initial events
        _fallbackToSimulator('No step events received from sensor');
      });
    } catch (e) {
      _fallbackToSimulator('Failed to start pedometer: $e');
    }
  }

  void _fallbackToSimulator(String message) {
    _nativeSub?.cancel();
    _nativeSub = null;
    _sensorTimeout?.cancel();
    _sensorTimeout = null;
    _errorController.add(message);
    _startSimulator();
  }

  void _startSimulator() {
    if (_simTimer != null) return;
    // keep simulated cumulative steps
    _simTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _simulatedSteps += DateTime.now().second % 4; // small deterministic increments
      _stepsController.add(_simulatedSteps);
    });
  }

  Future<void> stop() async {
    _nativeSub?.cancel();
    _nativeSub = null;
    _simTimer?.cancel();
    _simTimer = null;
    _sensorTimeout?.cancel();
    _sensorTimeout = null;
    _running = false;
  }

  Future<void> reset() async {
    _simulatedSteps = 0;
    _stepsController.add(0);
  }

  void dispose() {
    _stepsController.close();
    _errorController.close();
    _nativeSub?.cancel();
    _simTimer?.cancel();
    _sensorTimeout?.cancel();
  }
}
