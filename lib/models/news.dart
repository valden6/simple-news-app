import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
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

  News({
    required this.title,
    this.author,
    required this.source,
    required this.url,
    this.imgUrl,
    required this.datePublished,
    this.content,
  });

  factory News.fromJson({required Map<String, dynamic> json}) {
    return News(
      title: json["title"],
      author: json["author"],
      source: json["source"]["name"],
      url: json["url"],
      imgUrl: json["urlToImage"],
      datePublished: DateFormat('dd LLLL yyyy HH:mm', "FR").format(DateTime.parse(json["publishedAt"])),
      content: json["content"],
    );
  }
}
