import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScoreboardScreen extends StatefulWidget {
  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  List<int> _highScores = [];

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    final String? scoresString = prefs.getString('clickerHighScores');
    if (scoresString != null) {
      setState(() {
        _highScores = (json.decode(scoresString) as List<dynamic>).cast<int>();
        _highScores.sort((a, b) => b.compareTo(a)); // Sort in descending order
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scoreboard'),
      ),
      body: _highScores.isEmpty
          ? Center(child: Text('No high scores yet!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _highScores.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('#${index + 1}'),
                    ),
                    title: Text(
                      'Score: ${_highScores[index]}',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
