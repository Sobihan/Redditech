import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

Future<dynamic> searchSubreddits(String accessToken, String subreddit) async {
  var dio = Dio();
  final response = await dio.post(
      "https://oauth.reddit.com/api/search_subreddits.json?query=$subreddit",
      options: Options(headers: {
        "User-Agent": 'com.example.redditech (by /u/Sobihan)',
        'Authorization': 'bearer' + accessToken,
      }));
  return response;
}

Future<List> subredditsSubscribed(String accessToken) async {
  List mySubreddit = [];
  Uri uri = Uri.https('oauth.reddit.com', 'subreddits/mine/', {'limit': '100'});
  final response = await http.get(uri, headers: {
    'User-Agent': 'com.example.redditech (by /u/Sobihan)',
    'Authorization': 'bearer $accessToken',
  });

  var json = jsonDecode(response.body);
  for (int i = 0; i < json['data']['children'].length; i++) {
    mySubreddit.add(json['data']['children'][i]['data']['url']
        .toString()
        .split('/')[2]
        .toLowerCase());
  }
  return mySubreddit;
}

Future<dynamic> getSubredditsPost(String subreddit, String accessToken,
    {String sort = "new",
    int count = 0,
    String after = "",
    int limit = 25}) async {
  var dio = Dio();
  final response = await dio.get(
      "https://oauth.reddit.com/r/$subreddit/$sort.json?limit=$limit&count=$count&after=$after",
      options: Options(headers: {
        "User-Agent": 'com.example.redditech (by /u/Sobihan)',
        'Authorization': 'bearer' + accessToken,
      }));
  // developer.log(response.data['data']['children'][0]['data'].toString());
  // developer
  //     .log(response.data['data']['children'][0]['data']['title'].toString());
  // developer.log(response.data['data']['after'].toString());
  return response;
}

Future<String> getID(String subname) async {
  var dio = Dio();
  final response =
      await dio.get('https://www.reddit.com/r/$subname/about.json');
  return response.data['data']['name'];
}

Future<dynamic> subscribe(String subId, String accessToken) async {
  Uri uri = Uri.https("oauth.reddit.com", "api/subscribe/", {
    "action": "sub",
    "sr": subId,
    "skip_initial_defaults": "true",
    "X-Modhash": "null"
  });
  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'bearer ' + accessToken,
      'User-Agent': 'com.example.redditech (by /u/Sobihan)',
    },
  );
  return response;
}

Future<dynamic> unsubscribe(String subId, String accessToken) async {
  Uri uri = Uri.https("oauth.reddit.com", "api/subscribe/",
      {"action": "unsub", "sr": subId, "X-Modhash": "null"});
  final response = await http.post(
    uri,
    headers: {
      'Authorization': 'bearer ' + accessToken,
      'User-Agent': 'com.example.redditech (by /u/Sobihan)',
    },
  );
  return response;
}
