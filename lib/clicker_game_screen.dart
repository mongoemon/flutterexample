import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:my_flutter_project/scoreboard_screen.dart';

class ClickerGameScreen extends StatefulWidget {
  @override
  _ClickerGameScreenState createState() => _ClickerGameScreenState();
}

class _ClickerGameScreenState extends State<ClickerGameScreen> {
  int _counter = 0;
  int _timeLeft = 0;
  Timer? _timer;
  bool _gameStarted = false;
  bool _gameEnded = false;
  int _countdown = 0; // New variable for countdown
  int _lastGameDuration = 0; // Store the last game duration

  void _startGame(int duration) {
    setState(() {
      _counter = 0;
      _timeLeft = duration;
      _gameStarted = false; // Game not started yet, waiting for countdown
      _gameEnded = false;
      _countdown = 3; // Start 3-second countdown
      _lastGameDuration = duration; // Store the duration
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else if (!_gameStarted) {
          _gameStarted = true; // Game starts after countdown
          _timer?.cancel(); // Cancel countdown timer
          _timer = Timer.periodic(Duration(seconds: 1), (timer) { // Start game timer
            setState(() {
              if (_timeLeft > 0) {
                _timeLeft--;
              } else {
                _timer?.cancel();
                _gameEnded = true;
                _saveScore(_counter);
              }
            });
          });
        } else if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _gameEnded = true;
          _saveScore(_counter);
        }
      });
    });
  }

  Future<void> _saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> highScores = [];
    final String? scoresString = prefs.getString('clickerHighScores');
    if (scoresString != null) {
      highScores = (json.decode(scoresString) as List<dynamic>).cast<int>();
    }
    highScores.add(score);
    highScores.sort((a, b) => b.compareTo(a)); // Sort in descending order
    if (highScores.length > 3) {
      highScores = highScores.sublist(0, 3); // Keep only top 3
    }
    await prefs.setString('clickerHighScores', json.encode(highScores));
  }

  void _incrementCounter() {
    if (_gameStarted && !_gameEnded) {
      setState(() {
        _counter++;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clicker Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Clicks: $_counter',
              style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (_countdown > 0)
              Text(
                'Game starting in: $_countdown',
                style: TextStyle(fontSize: 36.0, color: Colors.blueAccent),
              )            
            else if (_gameStarted && !_gameEnded)
              Text(
                'Time Left: $_timeLeft seconds',
                style: TextStyle(fontSize: 24.0),
              )
            else if (_gameEnded)
              Column(
                children: [
                  Text(
                    'Game Over! You clicked $_counter times.',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _startGame(_lastGameDuration),
                    child: Text('Play Again'),
                  ),
                ],
              )
            else
              Text(
                'Select game duration to start.',
                style: TextStyle(fontSize: 24.0),
              ),
            SizedBox(height: 30),
            if (!_gameStarted && _countdown == 0 && !_gameEnded)
              Column(
                children: <Widget>[
                  Text(
                    'Select game duration:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _startGame(10),
                        child: Text('10 Seconds'),
                      ),
                      ElevatedButton(
                        onPressed: () => _startGame(30),
                        child: Text('30 Seconds'),
                      ),
                      ElevatedButton(
                        onPressed: () => _startGame(60),
                        child: Text('60 Seconds'),
                      ),
                    ],
                  ),
                ],
              ),
            if (_gameStarted && !_gameEnded)
              ElevatedButton(
                onPressed: _incrementCounter,
                child: Text('Click Me!', style: TextStyle(fontSize: 32.0)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
              ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back to Dashboard'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreboardScreen()));
              },
              child: Text('View Scoreboard'),
            ),
          ],
        ),
      ),
    );
  }
}
