import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  final String accessToken;
  const PostPage({Key? key, required this.accessToken}) : super(key: key);
  @override
  _PostPage createState() => _PostPage();
}

class _PostPage extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Text('Post Page: ${widget.accessToken}');
  }
}
