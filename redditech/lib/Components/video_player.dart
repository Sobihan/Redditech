import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);
  @override
  _VideoPlayer createState() => _VideoPlayer();
}

class _VideoPlayer extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer.network(
          widget.url,
          betterPlayerConfiguration: const BetterPlayerConfiguration(
              aspectRatio: 16 / 9, autoPlay: true),
        ));
  }
}
