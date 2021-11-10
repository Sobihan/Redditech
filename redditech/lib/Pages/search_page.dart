import 'package:flutter/material.dart';
import '../service.dart';
import '../Model/subreddit.dart';

class SearchPage extends StatefulWidget {
  final String accessToken;
  const SearchPage({Key? key, required this.accessToken}) : super(key: key);
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Subreddit> _subreddits = [];

  void onPressed() async {
    String data =
        await searchSubreddits(widget.accessToken, _controller.text.toString());
    setState(() {
      _subreddits = parseSubreddit(data);
    });
  }

  void cleanButton() {
    _controller.clear();
    setState(() {
      _subreddits.clear();
    });
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
                        title: Text(_subreddits[index].name, style: style),
                        leading: _subreddits[index].iconImage.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(_subreddits[index].iconImage))
                            : const CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Text('?', style: style)),
                        trailing: Text(
                          '${_subreddits[index].subscriberCount.toString()} subscribers',
                          style: style,
                        ));
                  }
                }))
      ],
    );
  }
}
