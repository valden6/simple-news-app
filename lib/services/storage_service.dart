import 'package:hive/hive.dart';
import 'package:test_technique/models/news.dart';

class StorageService {

  Future<void> saveNewsInStorage(News news) async {
    Box box = await Hive.openBox<News>('news');
    box.add(news);
  }

  void deleteNewsInStorage(News news) {
    final Box<News> box = Hive.box<News>('news');
    final List<News> boxNews = box.values.toList();
    for (final News newsInBox in boxNews) {
      if(newsInBox.url == news.url){
        box.delete(newsInBox.key);
      }
    }
  }

  Future<List<News>> getAllNewsInStorage() async {
    Box<News> box = await Hive.openBox<News>('news');
    return box.values.toList();
  }

}