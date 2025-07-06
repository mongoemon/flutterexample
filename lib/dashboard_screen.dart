import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_flutter_project/automation_testing_components_screen.dart';
import 'package:my_flutter_project/calculator_app_screen.dart';
import 'package:my_flutter_project/clicker_game_screen.dart';
import 'package:my_flutter_project/profile_screen.dart';
import 'package:my_flutter_project/credits_screen.dart';
import 'package:my_flutter_project/network_test_screen.dart';
import 'package:my_flutter_project/flutter_api_usage_screen.dart';
import 'package:my_flutter_project/turtle_jump_game_screen.dart';
import 'package:my_flutter_project/clicker_game_mode_selection_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String username;
  final String userRole;

  DashboardScreen({required this.username, this.userRole = 'admin'});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _name = 'User';
  String _nickname = 'User';
  String _apiUsageContent = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadApiUsageContent();
  }

  Future<void> _loadApiUsageContent() async {
    final String content = await DefaultAssetBundle.of(context).loadString('API_Flutter_Usage.md');
    setState(() {
      _apiUsageContent = content;
    });
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'User';
      _nickname = prefs.getString('nickname') ?? 'User';
    });
  }

  Future<void> _saveProfileData(String newName, String newNickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', newName);
    await prefs.setString('nickname', newNickname);
  }

  List<Widget> get _widgetOptions {
    List<Widget> options = [
      // Testing Tab Content
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Testing Components',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AutomationTestingComponentsScreen()));
                },
                child: Text('Sample of components for automation testing'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorAppScreen()));
                },
                child: Text('Calculator App'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NetworkTestScreen()));
                },
                child: Text('Network Test'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FlutterApiUsageScreen(apiUsageContent: _apiUsageContent)));
                },
                child: Text('Flutter API Usage'),
              ),
            ],
          ),
        ),
      ),

      // Profile Tab Content
      ProfileScreen(
        currentName: _name,
        currentNickname: _nickname,
        onEditProfile: (newName, newNickname) {
          setState(() {
            _name = newName;
            _nickname = newNickname;
          });
          _saveProfileData(newName, newNickname);
        },
      ),
    ];

    if (widget.userRole != 'tester') {
      options.insert(1,
        // Game Tab Content
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Games',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ClickerGameModeSelectionScreen()));
                  },
                  child: Text('Simple Clicker Game'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TurtleJumpGameScreen()));
                  },
                  child: Text('Turtle Jump Game'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return options;
  }

  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}!'),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bug_report),
            label: 'Testing',
          ),
          if (widget.userRole != 'tester')
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad),
              label: 'Game',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (widget.userRole == 'tester' && index > 0) {
            // Adjust index if Game tab is hidden for tester
            _onItemTapped(index + 1);
          } else {
            _onItemTapped(index);
          }
        },
      ),
      floatingActionButton: _selectedIndex == 0 ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreditsScreen()));
            },
            label: Text('Credits'),
            icon: Icon(Icons.info_outline),
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            label: Text('Logout'),
            icon: Icon(Icons.logout),
          ),
        ],
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
