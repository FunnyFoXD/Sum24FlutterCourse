import 'dart:async';
import 'package:education/templates/middleAssignment/results_screen.dart';
import 'package:flutter/material.dart';
import 'preferences.dart';
import 'results_screen.dart';

class TimerPage extends StatefulWidget {
  final PreferencesState preferencesState;
  const TimerPage({Key? key, required this.preferencesState}) : super(key: key);
  @override
  TimerPageState createState() => TimerPageState(preferencesState: PreferencesState(preferencesState.duration, preferencesState.minTemp, preferencesState.maxTemp));
}

class TimerPageState extends State<TimerPage> {
  final PreferencesState preferencesState;
  late int _minutes;
  late int _seconds;
  late int _secondsCopy;
  late int _minutesCopy;
  int secondsLeft = 0;
  bool _isRunning = false;
  bool _isPaused = true;
  bool _isHide = false;


  Timer? _timer;

  TimerPageState({required this.preferencesState}) {
    _minutes = preferencesState.duration;
    _seconds = 0;
    _secondsCopy = _seconds;
    _minutesCopy = _minutes;
  }
  

  void _pauseTimer() {
    _isPaused = true;
    _isRunning = false;
    setState(() => _timer?.cancel());
  }

  void _resumeTimer() {
    _isRunning = true;
    _isPaused = false;
  }

  void _toResultScreen() {
    _isPaused = true;
    _isRunning = false;
    setState(() => _timer?.cancel());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)
       => ResultsPage(timerPageState:
        TimerPageState(preferencesState:
         PreferencesState(preferencesState.duration,
          preferencesState.minTemp,
           preferencesState.maxTemp)), secondsLeft: secondsLeft,),
      ),
    );
  }


  void _startTimer() {
    _isRunning = true;
    _isPaused = false;
    _isHide = true;
    Timer.periodic(const Duration(seconds: 1), (timer)  {
      if (!_isPaused) {
        if (_secondsCopy == 0 && _minutesCopy != 0) {
          setState(() {
            _minutesCopy--;
            _secondsCopy = 59;
            setState(() {
              secondsLeft++;
            });
          });
        } else if (_minutesCopy == 0 && _secondsCopy == 0) {
          _toResultScreen();
        } else if (_secondsCopy > 0) {

          setState(() {
            secondsLeft++;
            _secondsCopy--;
          });
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer for shower'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Text(
              '${_minutesCopy.toString().padLeft(2,'0')}:${_secondsCopy.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isRunning || _isHide ? _toResultScreen : _startTimer,
                  child: Text(_isRunning || _isHide ? 'Stop': 'Start'),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _resumeTimer,
                  child: Text(_isPaused ? 'Resume' : 'Pause'),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
