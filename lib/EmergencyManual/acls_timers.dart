import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'acls_timers.g.dart';

@Riverpod(keepAlive: true)
class AclsTimers extends _$AclsTimers{
  /// Defines a set of timers for ACLS standard interventions, along with buttons to keep track of how many/when to give them

  /// Time since last pulse check
  final _pulseTimer = Stopwatch();

  /// Time since last Epi
  final _epiTimer = Stopwatch();

  /// Time since last Shock
  final _shockTimer = Stopwatch();

  /// Time since Code Started
  final _mainTimer = Stopwatch();

  /// Render Timer to update all text
  late Timer _renderTimer;

  /// Number of times intervention was done
  int _pulseChecks = 0;
  int _epiGiven = 0;
  int _shocksGiven = 0;

  /// Records interventions and times administered
  String _log = '';

  static String removeLastLine(String text) {
    List<String> lines = text.split('\n\n'); // Split the string into a list of lines
    if (lines.isEmpty) {
      return ''; // Handle empty string case
    }
    lines.removeLast(); // Remove the last line
    return lines.join('\n\n'); // Join the remaining lines back with newline characters
  }

  static String twoDigits(int n) {
    return n.toString().padLeft(2, "0");
  }

  static String formatTime(DateTime time) {
    return "${twoDigits(time.hour)}:${twoDigits(time.minute)}:${twoDigits(time.second)}";
  }

  @override
  Map<String,dynamic> build() {
    return {
      'epiTime': _epiTimer.elapsedMilliseconds,
      'pulseTime': _pulseTimer.elapsedMilliseconds,
      'shockTime': _shockTimer.elapsedMilliseconds,
      'mainTime': _mainTimer.elapsedMilliseconds,
      'pulseChecks': _pulseChecks,
      'epiGiven': _epiGiven,
      'shocksGiven': _shocksGiven,
      'running': _mainTimer.isRunning ? 1 : 0,
      'log': _log,
    };
  }
  
  void startMain() {
    if (!_mainTimer.isRunning) {
      DateTime now = DateTime.now();
      _log += _log.isEmpty ? '**${formatTime(now)}**\tCode Started\n\n' : '**${formatTime(now)}**\tCode Resumed\n\n';
      _mainTimer.start();
      _renderTimer = Timer.periodic(const Duration(milliseconds: 250), render);

      if (_pulseChecks == 0) {
        pulseCheck();
      }
    }

    render(_renderTimer);
  }

  void stopMain() {
    if (_mainTimer.isRunning) {
      _mainTimer.stop();

      _pulseTimer.stop();
      _epiTimer.stop();
      _shockTimer.stop();

      _renderTimer.cancel();

      DateTime now = DateTime.now();
      _log += '**${formatTime(now)}**\tCode Stopped\n\n';
      render(_renderTimer);
    }
  }

  void resetMain() {
    stopMain();

    _pulseTimer.stop();
    _pulseTimer.reset();
    _pulseChecks = 0;
    
    _epiTimer.stop();
    _epiTimer.reset();
    _epiGiven = 0;
    
    _shockTimer.stop();
    _shockTimer.reset();
    _shocksGiven = 0;

    _mainTimer.stop();
    _mainTimer.reset();

    _log = '';

    state = build();
  }

  void pulseCheck() {
    _pulseChecks++;

    startMain();

    _pulseTimer.reset();
    _pulseTimer.start();

    DateTime now = DateTime.now();
    _log += '**${formatTime(now)}**\tPulse Check #$_pulseChecks\n\n';

  }

  void giveEpi() {
    startMain();

    _epiTimer.reset();
    _epiTimer.start();
    _epiGiven++;

    DateTime now = DateTime.now();
    _log += '**${formatTime(now)}**\tEpi #$_epiGiven\n\n';
  }

  void giveShock() {
    startMain();
    _shockTimer.reset();
    _shockTimer.start();
    _shocksGiven++;

    DateTime now = DateTime.now();
    _log += '**${formatTime(now)}**\tShock #$_shocksGiven\n\n';

  }

  void render(Timer timer) {
    state = build();
  }

}