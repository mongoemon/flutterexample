import 'package:flutter/material.dart';

class FlutterApiUsageScreen extends StatelessWidget {
  final String apiUsageContent;

  const FlutterApiUsageScreen({Key? key, required this.apiUsageContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter API Usage'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          apiUsageContent,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
