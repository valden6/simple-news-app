import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_technique/app.dart';
import 'package:test_technique/models/news.dart';

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
    fontFamily: GoogleFonts.nunito().fontFamily
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.black,secondaryVariant: Colors.white)    
      ),
      home: const App(),
    );
  }
}
