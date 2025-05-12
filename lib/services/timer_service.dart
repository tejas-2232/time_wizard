import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timetrack/models/time_entry.dart';

enum TimerState { idle, running, paused }

class TimerService extends ChangeNotifier {
  TimerState _state = TimerState.idle;
  Timer? _timer;
  DateTime? _startTime;
  DateTime? _pauseTime;
  Duration _elapsed = Duration.zero;
  String? _currentTaskName;
  String? _currentProjectName;
  
  TimerState get state => _state;
  Duration get elapsed => _state == TimerState.running
      ? _elapsed + DateTime.now().difference(_startTime!)
      : _elapsed;
  String? get currentTaskName => _currentTaskName;
  String? get currentProjectName => _currentProjectName;
  bool get isRunning => _state == TimerState.running;
  bool get isPaused => _state == TimerState.paused;
  bool get isIdle => _state == TimerState.idle;
  
  String get formattedTime {
    final duration = elapsed;
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    
    return '$hours:$minutes:$seconds';
  }
  
  void start({String? taskName, String? projectName}) {
    if (_state == TimerState.idle) {
      _startTime = DateTime.now();
      _elapsed = Duration.zero;
    } else if (_state == TimerState.paused) {
      _startTime = DateTime.now();
      _elapsed = _elapsed;
    }
    
    _currentTaskName = taskName;
    _currentProjectName = projectName;
    _state = TimerState.running;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
    
    notifyListeners();
  }
  
  void pause() {
    if (_state != TimerState.running) return;
    
    _timer?.cancel();
    _pauseTime = DateTime.now();
    _elapsed = _elapsed + _pauseTime!.difference(_startTime!);
    _state = TimerState.paused;
    
    notifyListeners();
  }
  
  TimeEntry stop(String username) {
    final endTime = DateTime.now();
    
    TimeEntry entry;
    if (_state == TimerState.running) {
      final totalElapsed = _elapsed + endTime.difference(_startTime!);
      entry = TimeEntry(
        username: username,
        taskName: _currentTaskName,
        projectName: _currentProjectName,
        startTime: endTime.subtract(totalElapsed),
        endTime: endTime,
        isCompleted: true,
      );
    } else if (_state == TimerState.paused) {
      entry = TimeEntry(
        username: username,
        taskName: _currentTaskName,
        projectName: _currentProjectName,
        startTime: endTime.subtract(_elapsed),
        endTime: endTime,
        isCompleted: true,
      );
    } else {
      throw StateError('Cannot stop timer that is not running or paused');
    }
    
    _timer?.cancel();
    _timer = null;
    _startTime = null;
    _pauseTime = null;
    _elapsed = Duration.zero;
    _currentTaskName = null;
    _currentProjectName = null;
    _state = TimerState.idle;
    
    notifyListeners();
    return entry;
  }
  
  void reset() {
    _timer?.cancel();
    _timer = null;
    _startTime = null;
    _pauseTime = null;
    _elapsed = Duration.zero;
    _currentTaskName = null;
    _currentProjectName = null;
    _state = TimerState.idle;
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}