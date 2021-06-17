import 'package:http/http.dart';
import 'dart:convert';

import '../models/news.dart';

Future<List<News>> getNews(String query) async {
  String url =
      "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&language=en&apikey=6579572430ef41b99332d7382209a6de";

  final uri = Uri.parse(url);
  List<News> newsList = [];
  Response response = await get(uri);
  if (response.statusCode == 200) {
    Map data = jsonDecode(response.body);
    List articles = data['articles'];
    for (var article in articles) {
      News news = News(
          headline: article['title'],
          source: article['source']['name'],
          link: article['url'],
          image: article['urlToImage']);
      newsList.add(news);
    }
  } else {
    newsList = null;
  }
  return newsList;
}
