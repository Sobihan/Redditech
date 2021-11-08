import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

Future<String> searchSubreddits(String accessToken, String subreddit) async {
  Uri uri = Uri.https(
      'oauth.reddit.com', 'api/search_subreddits.json', {'query': subreddit});
  http.Response response = await http.post(
    uri,
    headers: {
      'User-Agent': 'com.example.redditech (by /u/Sobihan)',
      'Authorization': 'bearer $accessToken',
    },
  );
  if (response.statusCode == 200) {
    // print(response.body);
    return response.body;
  } else {
    return ("error");
  }
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
    // mySubreddit.add(json['data']['children'][i]['data']['name']);

    mySubreddit.add(json['data']['children'][i]['data']['url']
        .toString()
        .split('/')[2]
        .toLowerCase());
  }
  // String data = json.toString().replaceAll('&lt;', '<').replaceAll('&gt;', '>');

  return mySubreddit;
}

Future<String> getPosts(String accessToken, String subredditName,
    {String sort = "new",
    int count = 0,
    String after = "",
    int limit = 25}) async {
  Uri uri = Uri.https('oauth.reddit.com', 'r/$subredditName/$sort.json',
      {'limit': '$limit', 'count': '$count', 'after': '$after'});
  print(uri.toString());
  final response = await http.get(uri, headers: {
    'User-Agent': 'com.example.redditech (by /u/Sobihan)',
    'Authorization': 'bearer $accessToken',
  });
  print(response.statusCode);
  print(response.body);
  // print(response.body);
  return '';
}
