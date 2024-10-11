import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stopwatch/main.dart';

class Light extends StatefulWidget {
  const Light({super.key});

  @override
  State<Light> createState() => _LightState();
}

class _LightState extends State<Light> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  List<String> _lapTimes = [];
  final int _maxTimeInMilliseconds = 60000;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          // Update the progress based on the elapsed time within the current minute
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
    // Calculate progress as a fraction of the maximum time
    return (_stopwatch.elapsedMilliseconds % _maxTimeInMilliseconds) /
        _maxTimeInMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(_stopwatch.elapsedMilliseconds);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stopwatch',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StopwatchHome()),
              );
            },
            icon: Icon(
              Icons.sunny,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
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
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    trailing: Text(
                      _lapTimes[index],
                      style: TextStyle(color: Colors.black, fontSize: 20),
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
