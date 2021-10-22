import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:redditech/globals.dart' as globals;
import 'package:dio/dio.dart';
import 'dart:convert';

class loginpage extends StatefulWidget {
  login createState() => login();
}

class login extends State<loginpage> with TickerProviderStateMixin {
  bool reloading = false;
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
    setState(() {
      reloading = true;
    });
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
      setState(() {
        reloading = false;
      });
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
          reloading
              ? CircularProgressIndicator(
                  value: controller.value,
                  semanticsLabel: 'Linear progress indicator',
                  backgroundColor: Colors.grey,
                  color: Colors.orange[400],
                )
              : ElevatedButton(
                  style: style,
                  onPressed: signInReddit,
                  child: const Text('Connect with Reddit'),
                )
        ],
      ),
    );
  }
}
