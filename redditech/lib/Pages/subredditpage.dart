import 'package:flutter/material.dart';
import '../service.dart';
import 'package:redditech/Components/post.dart';

class SubredditPage extends StatefulWidget {
  final String accessToken;
  final String subredditName;
  const SubredditPage(
      {Key? key, required this.accessToken, required this.subredditName})
      : super(key: key);
  @override
  _SubredditPage createState() => _SubredditPage();
}

class _SubredditPage extends State<SubredditPage>
    with TickerProviderStateMixin {
  List _mySub = [];
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
    _mySub = await subredditsSubscribed(widget.accessToken);
    setState(() {
      reloading = true;
    });
    var response = await getSubredditsPost(
        widget.subredditName.toLowerCase(), widget.accessToken,
        sort: sort);
    for (int i = 0; i < response.data['data']['children'].length; i++) {
      String description =
          response.data['data']['children'][i]['data']['title'].toString();
      String url =
          response.data['data']['children'][i]['data']['url'].toString();
      _posts.add(Post(description: description, media: url));
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

  bool checkSub() {
    if (_mySub.contains(widget.subredditName.toLowerCase())) {
      return true;
    }
    return false;
  }

  void _subUnSub() async {
    bool isSub = checkSub();
    var id = await getID(widget.subredditName);

    if (!isSub) {
      var response = await subscribe(id, widget.accessToken);
    } else {
      var response = await unsubscribe(id, widget.accessToken);
    }
    var mySub = await subredditsSubscribed(widget.accessToken);
    setState(() {
      _mySub = mySub;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20), primary: Colors.red[400]);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[400],
          title: Text(widget.subredditName),
          actions: [
            IconButton(
                onPressed: () => {_subUnSub()},
                icon: Icon(checkSub() == true ? Icons.star : Icons.star_border))
          ],
        ),
        body: reloading
            ? Center(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const SizedBox(height: 30),
                CircularProgressIndicator(
                  value: controller.value,
                  semanticsLabel: 'Linear progress indicator',
                  backgroundColor: Colors.grey,
                  color: Colors.red[400],
                )
              ]))
            : Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
              ]));
  }
}
