import 'package:flutter/material.dart';

class AutomationTestingComponentsScreen extends StatefulWidget {
  @override
  _AutomationTestingComponentsScreenState createState() => _AutomationTestingComponentsScreenState();
}

class _AutomationTestingComponentsScreenState extends State<AutomationTestingComponentsScreen> {
  bool _checkboxValue = false;
  int _radioValue = 0;
  bool _switchValue = false;
  double _sliderValue = 0.5;
  String? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Automation Testing Components'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // Text
          Text(
            'Text Component',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('This is a sample text widget.'),
          SizedBox(height: 20),

          // TextField
          Text(
            'TextField Component',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your name',
            ),
          ),
          SizedBox(height: 20),

          // Buttons
          Text(
            'Button Components',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('Elevated Button'),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: Text('Text Button'),
          ),
          SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            child: Text('Outlined Button'),
          ),
          SizedBox(height: 20),

          // Checkbox
          Text(
            'Checkbox Component',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Checkbox(
                value: _checkboxValue,
                onChanged: (bool? newValue) {
                  setState(() {
                    _checkboxValue = newValue!;
                  });
                },
              ),
              Text('Checkbox Option'),
            ],
          ),
          SizedBox(height: 20),

          // Radio Buttons
          Text(
            'Radio Button Component',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: const Text('Option 1'),
                leading: Radio<int>(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: (int? value) {
                    setState(() {
                      _radioValue = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Option 2'),
                leading: Radio<int>(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (int? value) {
                    setState(() {
                      _radioValue = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Switch
          Text(
            'Switch Component',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Switch(
                value: _switchValue,
                onChanged: (bool newValue) {
                  setState(() {
                    _switchValue = newValue;
                  });
                },
              ),
              Text('Toggle Switch'),
            ],
          ),
          SizedBox(height: 20),

          // Slider
          Text(
            'Slider Component',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _sliderValue,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: _sliderValue.toStringAsFixed(1),
            onChanged: (double newValue) {
              setState(() {
                _sliderValue = newValue;
              });
            },
          ),
          SizedBox(height: 20),

          // Dropdown
          Text(
            'Dropdown Component',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _dropdownValue,
            hint: Text('Select an option'),
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue;
              });
            },
            items: <String>['Option A', 'Option B', 'Option C', 'Option D']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),

          // Progress Indicators
          Text(
            'Progress Indicators',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CircularProgressIndicator(),
          SizedBox(height: 20),
          LinearProgressIndicator(),
          SizedBox(height: 20),

          // Image (Placeholder)
          Text(
            'Image Component (Placeholder)',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            child: Center(
              child: Text('Image Placeholder', textAlign: TextAlign.center),
            ),
          ),
          SizedBox(height: 20),

          // Go Back Button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
