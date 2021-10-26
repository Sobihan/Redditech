import 'package:http/http.dart' as http;
import 'dart:convert';

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

Future<String> subredditsSubscribed(String accessToken) async {
  Uri uri = Uri.https(
      'oauth.reddit.com', 'subreddits/mine/subscriber.json', {'limit': '100'});
  final response = await http.get(uri, headers: {
    'User-Agent': 'com.example.redditech (by /u/Sobihan)',
    'Authorization': 'bearer $accessToken',
  });
  var json = jsonDecode(response.body);
  print(json);
  return response.statusCode == 200 ? response.body : "error";
}
