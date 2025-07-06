import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flutter_project/turtle_jump_leaderboard_screen.dart';
import 'dart:convert';

class TurtleJumpGameScreen extends StatefulWidget {
  @override
  _TurtleJumpGameScreenState createState() => _TurtleJumpGameScreenState();
}

class _TurtleJumpGameScreenState extends State<TurtleJumpGameScreen> with SingleTickerProviderStateMixin {
  static const double groundHeight = 50;
  static const double turtleSize = 50;
  static const double jumpStrength = 20; // Increased for higher jump
  static const double gravity = 0.2; // Decreased for longer air time
  static const double rockFixedSize = 30; // Fixed size for rocks
  double initialRockSpeed = 5;
  double rockSpeed = 5;
  int score = 0;
  int _highScore = 0;

  double turtleY = 0; // Relative to ground (0 is on ground, positive is up)
  double turtleVelocity = 0;
  bool isJumping = false;

  double rockX = 0; // Relative to right edge of screen (0 is right edge)
  double rockHeight = 0;
  bool isGameOver = false;
  bool _gameStarted = false; // New: controls if game is active or on start screen
  int _countdown = 0; // New: for start game countdown

  late AnimationController _controller;
  late Timer _gameLoopTimer;
  late Timer _rockSpawnTimer;
  Timer? _countdownTimer; // New: for countdown timer

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 16), // ~60 FPS
    )..addListener(() {
        _updateGame();
      });

    _loadHighScore();
    // Don't call _startGame() directly here, wait for button press
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresString = prefs.getString('turtleJumpHighScores');
    if (scoresString != null) {
      List<int> highScores = (json.decode(scoresString) as List<dynamic>).cast<int>();
      if (highScores.isNotEmpty) {
        setState(() {
          _highScore = highScores.reduce(max); // Get the highest score from the list
        });
      }
    }
  }

  Future<void> _saveHighScore(int newScore) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> highScores = [];
    final String? scoresString = prefs.getString('turtleJumpHighScores');
    if (scoresString != null) {
      highScores = (json.decode(scoresString) as List<dynamic>).cast<int>();
    }
    highScores.add(newScore);
    highScores.sort((a, b) => b.compareTo(a)); // Sort in descending order
    if (highScores.length > 3) {
      highScores = highScores.sublist(0, 3); // Keep only top 3
    }
    await prefs.setString('turtleJumpHighScores', json.encode(highScores));
    setState(() {
      _highScore = highScores.isNotEmpty ? highScores.first : 0; // Update _highScore from the sorted list
    });
  }

  void _startCountdown() {
    setState(() {
      _countdown = 3;
      _gameStarted = false; // Ensure game is not started during countdown
      isGameOver = false; // Reset game over state
      score = 0; // Reset score for new game
      rockSpeed = initialRockSpeed; // Reset speed
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _countdownTimer?.cancel();
          _startGame(); // Start the game after countdown
        }
      });
    });
  }

  void _startGame() {
    setState(() {
      turtleY = 0;
      turtleVelocity = 0;
      isJumping = false;
      rockX = MediaQuery.of(context).size.width; // Start rock off-screen right
      rockHeight = rockFixedSize;
      isGameOver = false;
      _gameStarted = true; // Game is now active
      score = 0; // Reset score for new game
      rockSpeed = initialRockSpeed; // Reset speed
    });

    _controller.repeat();
    _gameLoopTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      _updateGame();
    });
    _rockSpawnTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _spawnRock();
    });
  }

  void _updateGame() {
    if (isGameOver) return;

    // Apply gravity to turtle
    turtleVelocity -=
        gravity; // Gravity pulls down, so subtract from upward velocity
    turtleY += turtleVelocity; // Add velocity to move upwards

    // Prevent turtle from going below ground
    if (turtleY < 0) {
      turtleY = 0;
      turtleVelocity = 0;
      isJumping = false;
    }

    // Move rock
    rockX -= rockSpeed;
    if (rockX < -10) {
      // Rock went off screen, reset it
      rockX = MediaQuery.of(context).size.width;
      rockHeight = rockFixedSize; // Fixed size for rocks
      score++; // Increase score when rock passes
      _increaseDifficulty();
    }

    // Collision detection (simplified)
    final turtleRect = Rect.fromLTWH(
      50, // Fixed X position for turtle
      MediaQuery.of(context).size.height - groundHeight - turtleSize - turtleY,
      turtleSize,
      turtleSize,
    );

    final rockRect = Rect.fromLTWH(
      rockX,
      MediaQuery.of(context).size.height - groundHeight - rockHeight,
      30, // Rock width
      rockHeight,
    );

    if (turtleRect.overlaps(rockRect) && rockX > 0) {
      _gameOver();
    }

    setState(() {});
  }

  void _jump() {
    if (!isJumping) {
      setState(() {
        turtleVelocity = jumpStrength;
        isJumping = true;
      });
    }
  }

  void _spawnRock() {
    setState(() {
      rockX = MediaQuery.of(context).size.width;
      rockHeight = rockFixedSize;
    });
  }

  void _increaseDifficulty() {
    if (score > 0 && score % 10 == 0) {
      // Increase speed every 10 points
      rockSpeed += 0.5;
    }
  }

  void _gameOver() {
    setState(() {
      isGameOver = true;
      _gameStarted = false; // Game is no longer active
    });
    _saveHighScore(score); // Always save the score
    _controller.stop();
    _gameLoopTimer.cancel();
    _rockSpawnTimer.cancel();
    _countdownTimer?.cancel(); // Cancel countdown timer if active
  }

  @override
  void dispose() {
    _controller.dispose();
    _gameLoopTimer.cancel();
    _rockSpawnTimer.cancel();
    _countdownTimer?.cancel(); // Dispose countdown timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turtle Jump'),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          if (!_gameStarted && (_countdownTimer == null || !_countdownTimer!.isActive)) // Start screen
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _startCountdown,
                    child: Text('Start Game', style: TextStyle(fontSize: 24)),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TurtleJumpLeaderboardScreen()));
                    },
                    child: Text('Leaderboard', style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            )
          else if (_countdown > 0) // Countdown screen
            Center(
              child: Text(
                '$_countdown',
                style: TextStyle(fontSize: 96, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          else // Game screen
            GestureDetector(
              onTap: _jump,
              child: Stack(
                children: [
                  // Ground
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: groundHeight,
                    child: Container(color: Colors.brown.withOpacity(0.7)), // Semi-transparent ground
                  ),
                  // Turtle
                  Positioned(
                    bottom: groundHeight + turtleY,
                    left: 50,
                    child: Image.asset(
                      'assets/images/turtle.png',
                      width: turtleSize,
                      height: turtleSize,
                    ),
                  ),
                  // Rock
                  Positioned(
                    bottom: groundHeight,
                    left: rockX,
                    child: Image.asset(
                      'assets/images/rock.png',
                      width: 30,
                      height: rockHeight,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Score
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Text(
                      'Score: $score',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  // High Score
                  Positioned(
                    top: 80,
                    right: 20,
                    child: Text(
                      'High Score: $_highScore',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                  // Game Over Overlay
                  if (isGameOver)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Game Over!',
                                style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Final Score: $score',
                                style: TextStyle(fontSize: 32, color: Colors.white),
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: _startCountdown,
                                child: Text('Play Again', style: TextStyle(fontSize: 24)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
