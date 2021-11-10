import 'dart:convert';

class Subreddit {
  final int subscriberCount;
  final String iconImage;
  final String name;

  const Subreddit(
      {required this.subscriberCount,
      required this.iconImage,
      required this.name});

  factory Subreddit.fromJson(dynamic json) {
    return Subreddit(
        subscriberCount: json['subscriber_count'],
        iconImage: json['icon_img'],
        name: json['name']);
  }
}

List<Subreddit> parseSubreddit(String body) {
  var subredditobjJson = jsonDecode(body)["subreddits"] as List;
  List<Subreddit> subredditobj =
      subredditobjJson.map((tagJson) => Subreddit.fromJson(tagJson)).toList();
  return subredditobj;
}
