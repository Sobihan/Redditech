import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String accessToken;
  const ProfilePage({Key? key, required this.accessToken}) : super(key: key);
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Text('Profile Page ${widget.accessToken}');
  }
}
