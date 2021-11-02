import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:redditech/Components/post.dart';

class PostPage extends StatefulWidget {
  final String accessToken;
  const PostPage({Key? key, required this.accessToken}) : super(key: key);
  @override
  _PostPage createState() => _PostPage();
}

class _PostPage extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Post(description: "hello", media: "https://i.redd.it/4wz4e8fkr2x71.jpg")
      ],
    );
  }
}
