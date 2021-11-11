import 'package:flutter/material.dart';
import 'Pages/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> with TickerProviderStateMixin {
  String _accessToken = "";

  late AnimationController controller;
  @override
  void initState() {
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

  Future<bool> _isTokenValid(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('redditSoso');
    if (token != null) {
      List<String> values = token.split(',');
      var now = DateTime.now();
      if (now.difference(DateTime.parse(values[1])).inMinutes > 50) {
        return false;
      }
      setState(() {
        _accessToken = values[0];
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: FutureBuilder(
          future: _isTokenValid(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Navigation(accessToken: _accessToken);
              }
              return const Loginpage();
            } else {
              return (Center(
                  child: CircularProgressIndicator(
                value: controller.value,
                semanticsLabel: 'Linear progress indicator',
                backgroundColor: Colors.grey,
                color: Colors.red[400],
              )));
            }
          }),
    );
  }
}
