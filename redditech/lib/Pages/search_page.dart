import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String accessToken;
  const SearchPage({Key? key, required this.accessToken}) : super(key: key);
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  void onPressed() {
    print(_controller.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.go,
      onSubmitted: (value) => onPressed(),
      controller: _controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter a search term',
          suffixIcon: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.clear),
                  onPressed: _controller.clear,
                ),
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.send),
                  onPressed: onPressed,
                )
              ],
            ),
          )),
    );
  }
}
