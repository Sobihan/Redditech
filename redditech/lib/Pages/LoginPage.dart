import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class LoginPage extends StatelessWidget {
  void signinReddit() async {
    // const String id = 'd24KuCnv30paH6vY2-61Bw';
  }
  void signInReddit() async {
    // final String id = "d24KuCnv30paH6vY2-61Bw";
    final response = await FlutterWebAuth.authenticate(
        url:
            "https://www.reddit.com/api/v1/authorize?client_id=d24KuCnv30paH6vY2-61Bw&response_type=code&state=TEST&redirect_uri=com.example.redditech://callback&scope=read",
        callbackUrlScheme: "com.example.redditech");
    var uri = Uri.parse(response);
    print(uri.queryParameters['code']);
    print("Hello my friend");
  }

  Widget build(BuildContext context) {
    print("Hello");
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20), primary: Colors.orange[400]);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 30),
          ElevatedButton(
            style: style,
            onPressed: signInReddit,
            child: const Text('Connect with Reddit'),
          ),
        ],
      ),
    );
  }
}
