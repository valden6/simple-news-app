import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:simple_news_app/environment.dart';
import 'package:simple_news_app/models/news.dart';
import 'package:simple_news_app/models/source.dart';

class NewsService {

  final String apiKey = Environment.newsApiKeys;
  final String baseUrl = "https://newsapi.org/v2";

  Future<Response> get(String pathUrl) async {

    Dio dio = Dio();
    Response response = Response(requestOptions: RequestOptions(path: ""));

    try {
      response = await dio.get("$baseUrl$pathUrl&apiKey=$apiKey"); 
      log("API Response: ${response.statusCode} ${response.statusMessage}");
    } on DioError catch (e) {
      if(e.response != null){
        log("API Response: ${e.response!.statusCode} ${e.response!.statusMessage}");
        Map errorData = e.response!.data;
        if(errorData.containsKey("message")){
          log("Error Response message: ${errorData["message"]}");
        }
      } else {
        log("Error Response message: ${e.message}");
      }
    }

    return response;
  }

  Future<List<News>> getAllFrenchNews() async {
    final List<News> allNews = [];
    Response response = await get("/top-headlines?country=fr");
    String body = response.toString();
    Map data = jsonDecode(body);
    for (int i = 0; i < data["articles"].length; i++) {
      final News newsData = News.fromJson(data["articles"][i]);
      allNews.add(newsData);
    }

    return allNews;
  }

  Future<List<News>> getAllFrenchNewsBySource(Source source) async {
    final List<News> allNews = [];
    Response response = await get("/top-headlines?sources=${source.id}");
    String body = response.toString();
    Map data = jsonDecode(body);
    for (int i = 0; i < data["articles"].length; i++) {
      final News newsData = News.fromJson(data["articles"][i]);
      allNews.add(newsData);
    }

    return allNews;
  }

  Future<List<News>> getAllNewsByTitleSearch(String query) async {
    final List<News> allNews = [];
    Response response = await get("/everything?q=$query");
    String body = response.toString();
    Map data = jsonDecode(body);
    for (int i = 0; i < data["articles"].length; i++) {
      final News newsData = News.fromJson(data["articles"][i]);
      allNews.add(newsData);
    }

    return allNews;
  }

  Future<List<News>> getAllFrenchNewsByCategorySearch(String query) async {
    final List<News> allNews = [];
    Response response = await get("/top-headlines?country=fr&category=$query");
    String body = response.toString();
    Map data = jsonDecode(body);
    for (int i = 0; i < data["articles"].length; i++) {
      final News newsData = News.fromJson(data["articles"][i]);
      allNews.add(newsData);
    }

    return allNews;
  }

  Future<List<News>> getAllNewsBySourceSearch(String query) async {
    final List<News> allNews = [];
    
    final Source? source = await getSourceBySearch(query);
    if(source != null){
      Response response = await get("/top-headlines?sources=${source.id}");
      String body = response.toString();
      Map data = jsonDecode(body);
      for (int i = 0; i < data["articles"].length; i++) {
        final News newsData = News.fromJson(data["articles"][i]);
        allNews.add(newsData);
      }
    }
    return allNews;
  }

  Future<List<Source>> getAllFrenchSources() async {
    final List<Source> allSources = [];
    
    Response response = await get("/top-headlines/sources?country=fr");
    String body = response.toString();
    Map data = jsonDecode(body);
    for (int i = 0; i < data["sources"].length; i++) {
      final Source sourceData = Source.fromJson(data["sources"][i]);
      allSources.add(sourceData);
    }
    return allSources;
  }

  Future<Source?> getSourceBySearch(String query) async {
    final List<Source> allSources = [];
    Source? finalSource;
    
    Response response = await get("/top-headlines/sources?");
    String body = response.toString();
    Map data = jsonDecode(body);
    for (int i = 0; i < data["sources"].length; i++) {
      final Source sourceData = Source.fromJson(data["sources"][i]);
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