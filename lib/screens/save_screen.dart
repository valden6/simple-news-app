import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ionicons/ionicons.dart';
import 'package:simple_news_app/animations/slide_top_route.dart';
import 'package:simple_news_app/models/news.dart';
import 'package:simple_news_app/screens/news_detail_screen.dart';
import 'package:simple_news_app/services/storage_service.dart';

class SaveScreen extends StatefulWidget {

  const SaveScreen({ Key? key }) : super(key: key);

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {

  List<News> newsSavedList = [];
  ScrollController scrollController = ScrollController();
  bool scrollButton = false;


  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null);
    initializeNewsSaved();
    scrollController.addListener((){
      if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(scrollButton == true) {
            setState((){
              scrollButton = false;
            });
        }
      } else {
        if(scrollController.position.userScrollDirection == ScrollDirection.forward){
          if(scrollButton == false) {
               setState((){
                 scrollButton = true;
               });
           }
        }
    }});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> initializeNewsSaved() async {
    log("gettin all saved news...");
    final List<News> allNews = await StorageService().getAllNewsInStorage();
    setState(() {
      newsSavedList = allNews;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.center,
          child: Text("Mes news sauvegardées",style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 22,fontFamily: GoogleFonts.fugazOne().fontFamily)),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            if(newsSavedList.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 250),
                child: Center(
                  child: Column(
                    children: [
                      Icon(IconlyBold.bookmark,color: Theme.of(context).colorScheme.secondary,size: 30),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Text("Aucunes news",style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 20,fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            if(newsSavedList.isNotEmpty)
              ListView.builder(
                itemCount: newsSavedList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
      
                  final News news = newsSavedList[index];
      
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(context, SlideTopRoute(page: NewsDetailScreen(news: news)));
                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(news.title.split(" - ").first,style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold,fontSize: 14)),
                                  ),
                                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      StorageService().deleteNewsInStorage(news);
                                      setState(() {
                                        newsSavedList.removeAt(index);
                                      });
                                    },
                                    child: Icon(Ionicons.close_circle_outline,color: Theme.of(context).colorScheme.secondary,size: 25),
                                  )
                                ],
                              ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                              if(news.imgUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: 150,
                                    child: Image.network(news.imgUrl!),
                                  ),
                                ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Text(news.datePublished,style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold,fontSize: 14)),
                                    const Spacer(),
                                    Text(news.source,style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold,fontSize: 14))
                                  ],
                                ),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              )
          ],
        ),
      ),
      floatingActionButton: Visibility( 
        visible: scrollButton,
        child: FloatingActionButton(
          mini: true,
          onPressed: () {
            scrollController.animateTo(
              scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
            );
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(IconlyLight.arrowUp2,color: Theme.of(context).primaryColor),
        ),     
      ),
    );
  }
}
