import 'package:flutter/material.dart';
import 'package:redditech/Components/post.dart';
import '../service.dart';

class PostPage extends StatefulWidget {
  final String accessToken;
  const PostPage({Key? key, required this.accessToken}) : super(key: key);
  @override
  _PostPage createState() => _PostPage();
}

class _PostPage extends State<PostPage> with TickerProviderStateMixin {
  List _posts = [];
  bool reloading = true;
  late AnimationController controller;
  @override
  void initState() {
    _getPost();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _getPost() async {
    List data = await subredditsSubscribed(widget.accessToken);
    for (int i = 0; i < data.length; i++) {
      var response = await getSubredditsPost(data[i], widget.accessToken);
      for (int j = 0; j < response.data['data']['children'].length; j++) {
        String descrpition =
            response.data['data']['children'][j]['data']['title'].toString();
        String url =
            response.data['data']['children'][j]['data']['url'].toString();
        _posts.add(Post(description: descrpition, media: url));
      }
    }
    setState(() {
      _posts.shuffle();
      reloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          if (_posts.isEmpty) {
            return CircularProgressIndicator(
              value: controller.value,
              semanticsLabel: 'Linear progress indicator',
              backgroundColor: Colors.grey,
              color: Colors.red[400],
            );
          } else {
            return Container(
                color: Colors.orange,
                child: _posts[index],
                margin: const EdgeInsets.only(bottom: 10));
          }
        });
  }
}
