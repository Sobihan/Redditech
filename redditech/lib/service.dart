import 'package:http/http.dart' as http;

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
    return response.body;
  } else {
    return ("error");
  }
}
