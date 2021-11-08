import 'package:flutter/material.dart';
import '../Pages/post_page.dart';
import '../Pages/search_page.dart';
import '../Pages/profilepage.dart';

class Navigation extends StatefulWidget {
  final String accessToken;
  const Navigation({Key? key, required this.accessToken}) : super(key: key);
  @override
  _Navigation createState() => _Navigation();
}

class _Navigation extends State<Navigation> {
  int selectedIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      PostPage(accessToken: widget.accessToken),
      SearchPage(accessToken: widget.accessToken),
      ProfilePage(accessToken: widget.accessToken)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: const Text("Redditech"),
      ),
      resizeToAvoidBottomInset: false,
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red[400],
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Posts'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
