import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String accessToken;
  const SearchPage({Key? key, required this.accessToken}) : super(key: key);
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Text('Search page ${widget.accessToken}');
  }
}
