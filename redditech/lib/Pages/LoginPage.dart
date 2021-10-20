import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:redditech/globals.dart' as globals;

class loginPage extends StatelessWidget {
  void signInReddit() async {
    final response = await FlutterWebAuth.authenticate(
        url:
            'https://www.reddit.com/api/v1/authorize?client_id=${globals.clientID}&response_type=code&state=TEST&redirect_uri=com.example.redditech://callback&scope=read',
        callbackUrlScheme: "com.example.redditech");
    var uri = Uri.parse(response);
    print('Access Token: ${uri.queryParameters['code']}');
  }

  Widget build(BuildContext context) {
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
