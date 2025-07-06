import 'package:flutter/material.dart';
import 'package:my_flutter_project/credits_screen.dart';
import 'package:my_flutter_project/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentNickname;
  final Function(String, String) onEditProfile;

  ProfileScreen({
    required this.currentName,
    required this.currentNickname,
    required this.onEditProfile,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name;
  late String _nickname;

  @override
  void initState() {
    super.initState();
    _name = widget.currentName;
    _nickname = widget.currentNickname;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentName != oldWidget.currentName ||
        widget.currentNickname != oldWidget.currentNickname) {
      _name = widget.currentName;
      _nickname = widget.currentNickname;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.person, size: 100, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            'User Profile',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Name: $_name',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 10),
          Text(
            'Nickname: $_nickname',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    currentName: _name,
                    currentNickname: _nickname,
                  ),
                ),
              );
              if (result != null) {
                setState(() {
                  _name = result['name'];
                  _nickname = result['nickname'];
                });
                widget.onEditProfile(_name, _nickname);
              }
            },
            child: Text('Edit Profile'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreditsScreen()));
            },
            child: Text('Credits'),
          ),
        ],
      ),
    );
  }
}
