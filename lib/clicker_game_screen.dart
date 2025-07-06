import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:my_flutter_project/scoreboard_screen.dart';
import 'package:my_flutter_project/clicker_game_mode_selection_screen.dart'; // Import the new enum

class ClickerGameScreen extends StatefulWidget {
  final GameMode gameMode;

  ClickerGameScreen({required this.gameMode});

  @override
  _ClickerGameScreenState createState() => _ClickerGameScreenState();
}

class _ClickerGameScreenState extends State<ClickerGameScreen> {
  int _counter1 = 0;
  int _counter2 = 0;
  int _timeLeft = 0;
  Timer? _timer;
  bool _gameStarted = false;
  bool _gameEnded = false;
  int _countdown = 0; // New variable for countdown
  int _lastGameDuration = 0; // Store the last game duration
  String _winnerMessage = '';

  void _startGame(int duration) {
    setState(() {
      _counter1 = 0;
      _counter2 = 0;
      _timeLeft = duration;
      _gameStarted = false; // Game not started yet, waiting for countdown
      _gameEnded = false;
      _countdown = 3; // Start 3-second countdown
      _lastGameDuration = duration; // Store the duration
      _winnerMessage = '';
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else if (!_gameStarted) {
          _gameStarted = true; // Game starts after countdown
          _timer?.cancel(); // Cancel countdown timer
          _timer = Timer.periodic(Duration(seconds: 1), (timer) {
            // Start game timer
            setState(() {
              if (_timeLeft > 0) {
                _timeLeft--;
              } else {
                _timer?.cancel();
                _gameEnded = true;
                if (widget.gameMode == GameMode.onePlayer) {
                  _saveScore(_counter1);
                } else {
                  _determineWinner();
                }
              }
            });
          });
        } else if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _gameEnded = true;
          if (widget.gameMode == GameMode.onePlayer) {
            _saveScore(_counter1);
          } else {
            _determineWinner();
          }
        }
      });
    });
  }

  void _determineWinner() {
    if (_counter1 > _counter2) {
      _winnerMessage = 'Player 1 Wins!';
    } else if (_counter2 > _counter1) {
      _winnerMessage = 'Player 2 Wins!';
    } else {
      _winnerMessage = "It's a Tie!";
    }
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

  void _incrementCounter(int player) {
    if (_gameStarted && !_gameEnded) {
      setState(() {
        if (player == 1) {
          _counter1++;
        } else {
          _counter2++;
        }
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
        title: Text(widget.gameMode == GameMode.onePlayer ? 'Clicker Game (1 Player)' : 'Clicker Game (2 Players)'),
      ),
      body: widget.gameMode == GameMode.onePlayer
          ? _buildOnePlayerMode()
          : _buildTwoPlayerMode(),
    );
  }

  Widget _buildOnePlayerMode() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Clicks: $_counter1',
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
                  'Game Over! You clicked $_counter1 times.',
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
              onPressed: () => _incrementCounter(1),
              child: Text('Click Me!', style: TextStyle(fontSize: 32.0)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
            ),
          SizedBox(height: 30),
          SizedBox(height: 10),
          if ((!_gameStarted && _countdown == 0) || _gameEnded)
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreboardScreen()));
              },
              child: Text('View Scoreboard'),
            ),
        ],
      ),
    );
  }

  Widget _buildTwoPlayerMode() {
    return Column(
      children: [
        Expanded(
          child: RotatedBox(
            quarterTurns: 2, // Rotate 180 degrees for Player 2
            child: _buildPlayerArea(2),
          ),
        ),
        Divider(height: 2, color: Colors.grey),
        Expanded(
          child: _buildPlayerArea(1),
        ),
      ],
    );
  }

  Widget _buildPlayerArea(int playerNum) {
    int currentCounter = playerNum == 1 ? _counter1 : _counter2;
    return Container(
      color: playerNum == 1 ? Colors.blue.shade100 : Colors.red.shade100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Player $playerNum',
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Clicks: $currentCounter',
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
                    _winnerMessage,
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
                onPressed: () => _incrementCounter(playerNum),
                child: Text('Click Me!', style: TextStyle(fontSize: 32.0)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
              ),
            SizedBox(height: 30),
            SizedBox(height: 10),
            if (playerNum == 1 && ((!_gameStarted && _countdown == 0) || _gameEnded)) // Only show scoreboard button for Player 1's side
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
