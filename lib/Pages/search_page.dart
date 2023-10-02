import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../service.dart';
import '../Model/subreddit.dart';
import 'subredditpage.dart';

class SearchPage extends StatefulWidget {
  final String accessToken;
  const SearchPage({Key? key, required this.accessToken}) : super(key: key);
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Subreddit> _subreddits = [];
  List _mySub = [];

  void onPressed() async {
    List<Subreddit> sub = [];
    var response =
        await searchSubreddits(widget.accessToken, _controller.text.toString());
    for (int i = 0; i < response.data['subreddits'].length; i++) {
      var subreddit = response.data['subreddits'][i];
      sub.add(Subreddit(
          subscriberCount: subreddit['subscriber_count'],
          iconImage: subreddit['icon_img'],
          name: subreddit['name']));
    }
    var mySub = await subredditsSubscribed(widget.accessToken);
    setState(() {
      _subreddits = sub;
      _mySub = mySub;
    });
  }

  void cleanButton() {
    _controller.clear();
    setState(() {
      _subreddits.clear();
    });
  }

  bool checkSub(String subName) {
    if (_mySub.contains(subName.toLowerCase())) {
      return true;
    }
    return false;
  }

  void _subUnSub(String name) async {
    bool isSub = checkSub(name);
    var id = await getID(name);

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

  void gotoSubreddit(String subName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubredditPage(
                accessToken: widget.accessToken, subredditName: subName)));
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    return Column(
      children: [
        TextField(
          textInputAction: TextInputAction.go,
          onSubmitted: (value) => onPressed(),
          controller: _controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter a search term',
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      color: Colors.grey,
                      icon: const Icon(Icons.clear),
                      onPressed: cleanButton,
                    ),
                    IconButton(
                      color: Colors.red,
                      icon: const Icon(Icons.send),
                      onPressed: onPressed,
                    )
                  ],
                ),
              )),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: _subreddits.length,
                itemBuilder: (context, index) {
                  if (_subreddits.isEmpty) {
                    return Container();
                  } else {
                    return ListTile(
                      title: Text(
                          '${_subreddits[index].name}\n ${_subreddits[index].subscriberCount} subscribers',
                          style: style),
                      leading: _subreddits[index].iconImage.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(_subreddits[index].iconImage))
                          : const CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text('?', style: style)),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            onPressed: () =>
                                {_subUnSub(_subreddits[index].name)},
                            icon: Icon(checkSub(_subreddits[index].name) == true
                                ? Icons.star
                                : Icons.star_border)),
                        IconButton(
                            onPressed: () =>
                                {gotoSubreddit(_subreddits[index].name)},
                            icon: const Icon(Icons.remove_red_eye_rounded)),
                      ]),
                    );
                  }
                }))
      ],
    );
  }
}
