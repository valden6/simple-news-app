import 'package:hive/hive.dart';
part 'news.g.dart';

@HiveType(typeId: 0)
class News extends HiveObject {

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? author;

  @HiveField(2)
  final String source;

  @HiveField(3)
  final String url;

  @HiveField(4)
  final String? imgUrl;

  @HiveField(5)
  final String datePublished;

  @HiveField(6)
  final String? content;

  News(this.title, this.author, this.source, this.url, this.imgUrl, this.datePublished, this.content);

}