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
    TextStyle style = const TextStyle(fontSize: 20);
    if (widget.media.contains('null') || widget.media.contains('/comments/')) {
      return Text(widget.description, style: style);
    } else if (widget.media.contains('.mp4')) {
      return Column(
        children: [
          Text(widget.description, style: style),
          VideoPlayerScreen(url: widget.media)
        ],
      );
    } else if (widget.media.contains('.jpg') || widget.media.contains('.png')) {
      return Column(children: [
        Text(widget.description, style: style),
        Image.network(widget.media, fit: BoxFit.fitWidth)
      ]);
    } else {
      return Text(widget.description, style: style);
    }
  }
}
