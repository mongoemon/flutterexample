import 'package:flutter/material.dart';
import 'package:my_flutter_project/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Simulate backend response based on credentials
    if (username == 'user' && password == 'password') {
      // Simulate a successful login (HTTP 200 OK)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful!')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(username: username, userRole: 'admin')));
    } else if (username == 'tester' && password == 'password') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful as Tester!')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(username: username, userRole: 'tester')));
    } else {
      // Simulate an unsuccessful login (HTTP 401 Unauthorized)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: Invalid credentials (401)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(username: 'Guest', userRole: 'admin')));
              },
              child: Text('Login as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}
