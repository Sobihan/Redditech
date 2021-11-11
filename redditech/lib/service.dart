import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:developer' as developer;

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

Future<Map<String, String>> getProfil(String accessToken) async {
  Map<String, String> profil;
  Uri uri = Uri.https("oauth.reddit.com", "api/v1/me");
  final response = await http.get(uri, headers: {
    'Authorization': 'bearer ' + accessToken,
    'User-Agent': 'com.example.redditech (by /u/Sobihan)',
  });
  var json = jsonDecode(response.body);
  developer.log(json['icon_img'].toString());
  profil = {
    "username": json['subreddit']['display_name'].toString(),
    "img": json['icon_img'].split('?')[0].toString(),
    "coins": json['subreddit']['coins'].toString(),
    "subscribers": json['subreddit']['subscribers'].toString(),
    "header_img": json['subreddit']['banner_img'].split('?')[0].toString()
  };
  return profil;
}
