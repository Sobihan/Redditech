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
  String sort = "new";
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
    setState(() {
      reloading = true;
    });
    List data = await subredditsSubscribed(widget.accessToken);
    for (int i = 0; i < data.length; i++) {
      var response =
          await getSubredditsPost(data[i], widget.accessToken, sort: sort);
      for (int j = 0; j < response.data['data']['children'].length; j++) {
        String descrpition =
            'r/${response.data['data']['children'][j]['data']['subreddit'].toString()}/${response.data['data']['children'][j]['data']['title'].toString()}';
        String url =
            response.data['data']['children'][j]['data']['url'].toString();
        _posts.add(Post(description: descrpition, media: url));
      }
    }
    setState(() {
      reloading = false;
    });
  }

  void reload(String stateSort) async {
    setState(() {
      sort = stateSort;
      _posts.clear();
    });
    _getPost();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20), primary: Colors.red[400]);
    if (reloading) {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const SizedBox(height: 30),
        CircularProgressIndicator(
          value: controller.value,
          semanticsLabel: 'Linear progress indicator',
          backgroundColor: Colors.grey,
          color: Colors.red[400],
        )
      ]));
    } else {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ElevatedButton(
            style: style,
            onPressed: () => {reload('best')},
            child: const Text('Best'),
          ),
          ElevatedButton(
            style: style,
            onPressed: () => {reload('hot')},
            child: const Text('Hot'),
          ),
          ElevatedButton(
            style: style,
            onPressed: () => {reload('new')},
            child: const Text('New'),
          )
        ]),
        Expanded(
            child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return Container(
                      color: Colors.orange,
                      child: _posts[index],
                      margin: const EdgeInsets.only(bottom: 20));
                }))
      ]);
    }
  }
}
