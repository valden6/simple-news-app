import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_news_app/animations/swipe_back.dart';
import 'package:simple_news_app/models/news.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {

  final News news;

  const NewsDetailScreen({ Key? key, required this.news }) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {

  List<News> newsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void launchURL(String url) async {
    if (!await launchUrl(Uri(path: url))) throw "Could not launch $url";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          child: Icon(IconlyLight.arrowDown2,color: Theme.of(context).colorScheme.secondary,size: 30),
        ),
        title: Text("En détail",style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 22,fontFamily: GoogleFonts.fugazOne().fontFamily))
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) => SwipeBack().onVerticalDragDown(context, details),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(widget.news.title.split(" - ").first,style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold,fontSize: 14)),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    if(widget.news.imgUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 150,
                          child: Image.network(widget.news.imgUrl!),
                        ),
                      ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(widget.news.content.toString(),style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold,fontSize: 14)),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            launchURL(widget.news.url);
                          },
                          child: Card(
                            color: Theme.of(context).colorScheme.secondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text("Page de l'article",style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer,fontWeight: FontWeight.bold,fontSize: 12)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Share.share("Regarde cet article ! \n${widget.news.url}"); 
                          },
                          child: Card(
                            color: Theme.of(context).colorScheme.secondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(IconlyLight.send,color: Theme.of(context).colorScheme.secondaryContainer,size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(widget.news.datePublished,style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold,fontSize: 14)),
                          const Spacer(),
                          Text(widget.news.source,style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold,fontSize: 14))
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}