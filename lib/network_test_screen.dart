import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkTestScreen extends StatefulWidget {
  @override
  _NetworkTestScreenState createState() => _NetworkTestScreenState();
}

class _NetworkTestScreenState extends State<NetworkTestScreen> {
  String _responseBody = 'No request made yet.';

  Future<void> _makeRequest(Future<http.Response> Function() requestFunction) async {
    setState(() {
      _responseBody = 'Making request...';
    });
    try {
      final response = await requestFunction();
      setState(() {
        _responseBody = 'Status: ${response.statusCode}\nBody: ${json.encode(json.decode(response.body))}';
      });
    } catch (e) {
      setState(() {
        _responseBody = 'Exception: $e';
      });
    }
  }

  Future<http.Response> _getExample() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
  }

  Future<http.Response> _postExample() {
    return http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': 'foo',
        'body': 'bar',
        'userId': '1',
      }),
    );
  }

  Future<http.Response> _putExample() {
    return http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': '1',
        'title': 'foo updated',
        'body': 'bar updated',
        'userId': '1',
      }),
    );
  }

  Future<http.Response> _deleteExample() {
    return http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _makeRequest(_getExample),
              child: Text('Make GET Request'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _makeRequest(_postExample),
              child: Text('Make POST Request'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _makeRequest(_putExample),
              child: Text('Make PUT Request'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _makeRequest(_deleteExample),
              child: Text('Make DELETE Request'),
            ),
            SizedBox(height: 20),
            Text(
              'Response:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_responseBody),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
