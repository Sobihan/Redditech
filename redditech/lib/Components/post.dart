import 'package:flutter/material.dart';
import 'video_player.dart';

class Post extends StatefulWidget {
  final String description;
  final String media;
  const Post({Key? key, required this.description, required this.media})
      : super(key: key);
  @override
  _Post createState() => _Post();
}

class _Post extends State<Post> {
  @override
  Widget build(BuildContext context) {
    if (widget.media.contains('null')) {
      return Text(widget.description);
    } else if (widget.media.contains('.mp4')) {
      return Column(
        children: [Text(widget.description)],
      );
    } else {
      print('heuu');
      return Column(children: [
        Text(widget.description),
        Image.network(widget.media, fit: BoxFit.fitWidth)
      ]);
    }
  }
}
