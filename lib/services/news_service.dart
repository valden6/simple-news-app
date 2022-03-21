import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:test_technique/environment.dart';
import 'package:test_technique/models/news.dart';
import 'package:test_technique/models/source.dart';

class NewsService {

  final String apiKey = Environment.newsApiKeys;

  Future<List<News>> getAllFrenchNews() async {
    final List<News> allNews = [];
    Dio dio = Dio();
    Response response = await dio.get("https://newsapi.org/v2/top-headlines?country=fr&apiKey=$apiKey");
    String body = response.toString();
    // log(body);
    Map data = jsonDecode(body);
    for (int i = 0; i < data["articles"].length; i++) {
      final datePublished = DateFormat('dd LLLL yyyy HH:mm',"FR").format(DateTime.parse(data["articles"][i]["publishedAt"]));
      final News newsData = News(
        data["articles"][i]["title"],
        data["articles"][i]["author"],
        data["articles"][i]["source"]["name"],
        data["articles"][i]["url"],
        data["articles"][i]["urlToImage"],
        datePublished,
        data["articles"][i]["content"]
      );
      allNews.add(newsData);
    }

    return allNews;
  }

  Future<List<News>> getAllFrenchNewsBySource(Source source) async {
    final List<News> allNews = [];
    Dio dio = Dio();
    Response response = await dio.get("https://newsapi.org/v2/top-headlines?sources=${source.id}&apiKey=$apiKey");
    String body = response.toString();
    // log(body);
    Map data = jsonDecode(body);
    for (int i = 0; i < data["articles"].length; i++) {
      final datePublished = DateFormat('dd LLLL yyyy HH:mm',"FR").format(DateTime.parse(data["articles"][i]["publishedAt"]));
      final News newsData = News(
        data["articles"][i]["title"],
        data["articles"][i]["author"],
        data["articles"][i]["source"]["name"],
        data["articles"][i]["url"],
        data["articles"][i]["urlToImage"],
        datePublished,
        data["articles"][i]["content"]
      );
      allNews.add(newsData);
    }

    return allNews;
  }

  Future<List<News>> getAllNewsByTitleSearch(String query) async {
    final List<News> allNews = [];
    Dio dio = Dio();
    Response response = await dio.get("https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey");
    String body = response.toString();
    // log(body);
    Map data = jsonDecode(body);
    for (int i = 0; i < data["articles"].length; i++) {
      final datePublished = DateFormat('dd LLLL yyyy HH:mm',"FR").format(DateTime.parse(data["articles"][i]["publishedAt"]));
      final News newsData = News(
        data["articles"][i]["title"],
        data["articles"][i]["author"],
        data["articles"][i]["source"]["name"],
        data["articles"][i]["url"],
        data["articles"][i]["urlToImage"],
        datePublished,
        data["articles"][i]["content"]
      );
      allNews.add(newsData);
    }

    return allNews;
  }

  Future<List<News>> getAllFrenchNewsByCategorySearch(String query) async {
    final List<News> allNews = [];
    Dio dio = Dio();
    Response response = await dio.get("https://newsapi.org/v2/top-headlines?country=fr&category=$query&apiKey=$apiKey");
    String body = response.toString();
    // log(body);
    Map data = jsonDecode(body);
    for (int i = 0; i < data["articles"].length; i++) {
      final datePublished = DateFormat('dd LLLL yyyy HH:mm',"FR").format(DateTime.parse(data["articles"][i]["publishedAt"]));
      final News newsData = News(
        data["articles"][i]["title"],
        data["articles"][i]["author"],
        data["articles"][i]["source"]["name"],
        data["articles"][i]["url"],
        data["articles"][i]["urlToImage"],
        datePublished,
        data["articles"][i]["content"]
      );
      allNews.add(newsData);
    }

    return allNews;
  }

  Future<List<News>> getAllNewsBySourceSearch(String query) async {
    final List<News> allNews = [];
    Dio dio = Dio();
    final Source? source = await getSourceBySearch(query);
    if(source != null){
      Response response = await dio.get("https://newsapi.org/v2/top-headlines?sources=${source.id}&apiKey=$apiKey");
      String body = response.toString();
      // log(body);
      Map data = jsonDecode(body);
      for (int i = 0; i < data["articles"].length; i++) {
        final datePublished = DateFormat('dd LLLL yyyy HH:mm',"FR").format(DateTime.parse(data["articles"][i]["publishedAt"]));
        final News newsData = News(
          data["articles"][i]["title"],
          data["articles"][i]["author"],
          data["articles"][i]["source"]["name"],
          data["articles"][i]["url"],
          data["articles"][i]["urlToImage"],
          datePublished,
          data["articles"][i]["content"]
        );
        allNews.add(newsData);
      }
    }
    return allNews;
  }

  Future<List<Source>> getAllFrenchSources() async {
    final List<Source> allSources = [];
    Dio dio = Dio();
    Response response = await dio.get("https://newsapi.org/v2/top-headlines/sources?country=fr&apiKey=$apiKey");
    String body = response.toString();
    // log(body);
    Map data = jsonDecode(body);
    for (int i = 0; i < data["sources"].length; i++) {
      final Source sourceData = Source(
        data["sources"][i]["name"],
        data["sources"][i]["id"],
        data["sources"][i]["description"],
        data["sources"][i]["url"],
        data["sources"][i]["category"],
        data["sources"][i]["country"],
      );
      allSources.add(sourceData);
    }
    return allSources;
  }

  Future<Source?> getSourceBySearch(String query) async {
    final List<Source> allSources = [];
    Source? finalSource;
    Dio dio = Dio();
    Response response = await dio.get("https://newsapi.org/v2/top-headlines/sources?apiKey=$apiKey");
    String body = response.toString();
    // log(body);
    Map data = jsonDecode(body);
    for (int i = 0; i < data["sources"].length; i++) {
      final Source sourceData = Source(
        data["sources"][i]["name"],
        data["sources"][i]["id"],
        data["sources"][i]["description"],
        data["sources"][i]["url"],
        data["sources"][i]["category"],
        data["sources"][i]["country"],
      );
      allSources.add(sourceData);
    }
    for (final Source source in allSources) {
      if(source.name.toLowerCase().replaceAll(" ", "").contains(query.toLowerCase().replaceAll(" ", ""))){
        finalSource = source;
      }
    }
    return finalSource;
  }
  
}