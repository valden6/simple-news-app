import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_news_app/app.dart';
import 'package:simple_news_app/models/news.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); 
  Hive.registerAdapter(NewsAdapter());
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  
  const NewsApp({Key? key}) : super(key: key);

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  
  final ThemeData theme = ThemeData(
    primaryColor: Colors.grey[200],
    fontFamily: GoogleFonts.barlow().fontFamily
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        splashColor: Colors.transparent,
        colorScheme: theme.colorScheme.copyWith(
          secondaryContainer: Colors.white,
          secondary: Colors.black
        )    
      ),
      home: const App(),
    );
  }
}
