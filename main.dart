import 'package:flutter/material.dart';
import 'dart:async';
import 'package:stopwatch/light.dart';

void main() => runApp(StopwatchApp());

class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StopwatchHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StopwatchHome extends StatefulWidget {
  @override
  _StopwatchHomeState createState() => _StopwatchHomeState();
}

class _StopwatchHomeState extends State<StopwatchHome> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  List<String> _lapTimes = [];
  final int _maxTimeInMilliseconds = 60000; // 1 minute in milliseconds

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();

    // Timer to update the progress and UI every 100 milliseconds
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          // Trigger rebuild to update the UI
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
    setState(() {});
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {
      _lapTimes.clear();
    });
  }

  void _recordLapTime() {
    if (_stopwatch.isRunning) {
      setState(() {
        _lapTimes.add(_formatTime(_stopwatch.elapsedMilliseconds));
      });
    }
  }

  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr.$hundredsStr";
  }

  double _getProgress() {
    int elapsedTime = _stopwatch.elapsedMilliseconds % _maxTimeInMilliseconds;
    return elapsedTime / _maxTimeInMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(_stopwatch.elapsedMilliseconds);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stopwatch',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Light()),
              );
            },
            icon: Icon(
              Icons.sunny,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150.0),
            SizedBox(
              height: 250.0,
              width: 250.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: _getProgress(),
                    strokeWidth: 8.0,
                    color: Color.fromARGB(255, 237, 119, 9),
                  ),
                  Center(
                    child: Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 40.0, //stopwatch
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _startStopwatch,
                  child: Text(
                    _stopwatch.isRunning ? 'Stop' : 'Start',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 237, 119, 9),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  child: Text(
                    'Reset',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 237, 119, 9),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: _recordLapTime,
                  child: Text(
                    'Lap',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 237, 119, 9),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _lapTimes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Lap ${index + 1}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    trailing: Text(
                      _lapTimes[index],
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
