import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:redditech/globals.dart' as globals;
import 'package:dio/dio.dart';
import 'dart:convert';

class loginPage extends StatelessWidget {
  Future<Uri> getRedditCode() async {
    final response = await FlutterWebAuth.authenticate(
        url:
            'https://www.reddit.com/api/v1/authorize?client_id=${globals.clientID}&response_type=code&state=TEST&redirect_uri=com.example.redditech://callback&scope=read',
        callbackUrlScheme: "com.example.redditech");
    Uri uri = Uri.parse(response);
    print('Code: ${uri.queryParameters['code']}');
    return uri;
  }

  void signInReddit() async {
    String password = "";
    String basicAuth =
        "Basic " + base64Encode(utf8.encode('${globals.clientID}:$password'));
    var dio = Dio();
    final uri = await getRedditCode();
    final responseAuth = await dio.post(
        "https://www.reddit.com/api/v1/access_token",
        data:
            "grant_type=authorization_code&code=${uri.queryParameters['code']}&redirect_uri=com.example.redditech://callback",
        options: Options(headers: {
          "Authorization": basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded'
        }));
    if (responseAuth.statusCode == 200) {
      print('Access Token: ${responseAuth.data['access_token']}');
    } else {
      print("Error on Access Token");
    }
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
