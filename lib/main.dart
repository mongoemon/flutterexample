import 'package:flutter/material.dart';
import 'package:my_flutter_project/login_screen.dart';
import 'package:my_flutter_project/dashboard_screen.dart';
import 'package:my_flutter_project/automation_testing_components_screen.dart';
import 'package:my_flutter_project/calculator_app_screen.dart';
import 'package:my_flutter_project/credits_screen.dart';
import 'package:my_flutter_project/clicker_game_screen.dart';
import 'package:my_flutter_project/clicker_game_mode_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        
        '/automation_components': (context) => AutomationTestingComponentsScreen(),
        '/calculator_app': (context) => CalculatorAppScreen(),
        '/credits': (context) => CreditsScreen(),
        '/clicker_game': (context) => ClickerGameModeSelectionScreen(),
      },
    );
  }
}