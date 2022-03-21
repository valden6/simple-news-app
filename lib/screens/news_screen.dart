import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:test_technique/animations/slide_top_route.dart';
import 'package:test_technique/models/news.dart';
import 'package:test_technique/models/source.dart';
import 'package:test_technique/screens/news_detail_screen.dart';
import 'package:test_technique/services/news_service.dart';
import 'package:test_technique/services/storage_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({ Key? key }) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  List<News> newsList = [];
  List<Source> sourceList = [];
  Source? sourceSelected;
  List<bool> newsSaveList = [];
  String criteria = "Titre";
  String query = "";
  final FocusNode focusNodeSearch = FocusNode();
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  final RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null);
    initializeData();
  }

  @override
  void dispose() {
    refreshController.dispose();
    searchController.dispose();
    focusNodeSearch.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async{
    await initializeData();
    setState(() {
      query = "";
      isSearching = false;
    });
    refreshController.refreshCompleted();
  }

  Future<void> initializeData() async{
    await initializeNews();
    await initializeSources();
  }

  Future<void> initializeNews() async {
    log("gettin all news...");
    final List<News> allNews = await NewsService().getAllFrenchNews();
    initializeSaveNewsList(allNews);
    setState(() {
      newsList = allNews;
    });
  }

  Future<void> initializeNewsBySource(Source source) async {
    log("gettin all news by ${source.name}...");
    final List<News> allNews = await NewsService().getAllFrenchNewsBySource(source);
    initializeSaveNewsList(allNews);
    setState(() {
      newsList = allNews;
    });
  }

  Future<void> initializeSources() async {
    log("gettin all sources...");
    final List<Source> allSources = await NewsService().getAllFrenchSources();
    sourceList.clear();
    setState(() {
      sourceList = allSources;
    });
  }

  void initializeSaveNewsList(List<News> newsList){
    final List<bool> saveNews = [];

    for (int i = 0; i < newsList.length; i++) {
      saveNews.add(false);
    }

    setState(() {
      newsSaveList = saveNews;
    });
  }

  Future<void> searchNewsByCriteria() async {
    log("gettin all by search criteria...");
    final List<News> allNews = [];
    if(criteria == "Titre"){
      final List<News> allNewsData = await NewsService().getAllNewsByTitleSearch(searchController.text); 
      allNews.addAll(allNewsData);
    } else if (criteria == "Source"){
      final List<News> allNewsData = await NewsService().getAllNewsBySourceSearch(searchController.text); 
      allNews.addAll(allNewsData);
    } else {
      final List<News> allNewsData = await NewsService().getAllFrenchNewsByCategorySearch(searchController.text); 
      allNews.addAll(allNewsData);
    }
    initializeSaveNewsList(allNews);
    setState(() {
      newsList = allNews;
    });
  }

  bool checkIsSourceSelected(Source source){
    bool isSelected = false;

    if(sourceSelected != null && sourceSelected == source){
      isSelected = true;
    }

    return isSelected;
  }

  Future<bool> onSaveButtonTapped(News news, int index) async { 
    
    HapticFeedback.heavyImpact();

    bool success = false;

    if(newsSaveList[index]){
      log("Deleting news from local...");
      StorageService().deleteNewsInStorage(news);
      success = true;
    } else {
      log("Saving news from local...");
      StorageService().saveNewsInStorage(news);
      success = true;
    }

    setState(() {
      newsSaveList[index] = !newsSaveList[index];
    });

    return success;
  }

  Row showSearchCriteria(BuildContext context){

    Color backgroundColorTitle;
    Color textColorTitle;
    Color backgroundColorSource;
    Color textColorSource;
    Color backgroundColorCategory;
    Color textColorCategory;

    switch (criteria) {
      case "Titre":
        backgroundColorTitle = Theme.of(context).colorScheme.secondary;
        textColorTitle = Theme.of(context).colorScheme.secondaryVariant;
        backgroundColorSource = Theme.of(context).colorScheme.secondaryVariant;
        textColorSource = Theme.of(context).colorScheme.secondary;
        backgroundColorCategory = Theme.of(context).colorScheme.secondaryVariant;
        textColorCategory = Theme.of(context).colorScheme.secondary;
        break;
      case "Source":
        backgroundColorTitle = Theme.of(context).colorScheme.secondaryVariant;
        textColorTitle = Theme.of(context).colorScheme.secondary;
        backgroundColorSource = Theme.of(context).colorScheme.secondary;
        textColorSource = Theme.of(context).colorScheme.secondaryVariant;
        backgroundColorCategory = Theme.of(context).colorScheme.secondaryVariant;
        textColorCategory = Theme.of(context).colorScheme.secondary;
        break;
      default:
        backgroundColorTitle = Theme.of(context).colorScheme.secondaryVariant;
        textColorTitle = Theme.of(context).colorScheme.secondary;
        backgroundColorSource = Theme.of(context).colorScheme.secondaryVariant;
        textColorSource = Theme.of(context).colorScheme.secondary;
        backgroundColorCategory = Theme.of(context).colorScheme.secondary;
        textColorCategory = Theme.of(context).colorScheme.secondaryVariant;
        break;
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              searchController.text = "";
              criteria = "Titre";
            });
          },
          child: Card(
            elevation: 2,
            color: backgroundColorTitle,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(child: Text("Titre",style: TextStyle(color: textColorTitle,fontSize: 14))),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              searchController.text = "";
              criteria = "Source";
            });
          },
          child: Card(
            elevation: 2,
            color: backgroundColorSource,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(child: Text("Source",style: TextStyle(color: textColorSource,fontSize: 14))),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              searchController.text = "";
              criteria = "Catégories";
            });
          },
          child: Card(
            elevation: 2,
            color: backgroundColorCategory,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(child: Text("Catégories",style: TextStyle(color: textColorCategory,fontSize: 14))),
            ),
          ),
        ),
      ],
    );
  }

  Text showDynamicTitle(){

    String text = "";

    if(isSearching){
      text = "a la une de: $query";
    } else if(sourceSelected != null){
      text = "a la une de ${sourceSelected!.name}";
    } else {
      text = "a la une";
    }

    return Text(text,style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 26,fontFamily: GoogleFonts.pacifico().fontFamily));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        preferredSize: isSearching ? const Size.fromHeight(100) : const Size.fromHeight(45),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            bottom: false,
            child: Column(
              children: [
                if(!isSearching)
                  Text("Les news",style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 22,fontFamily: GoogleFonts.pacifico().fontFamily)),
                if(isSearching)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 60,top: 6),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryVariant,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: TextField(
                            cursorColor: Theme.of(context).colorScheme.secondary,
                            focusNode: focusNodeSearch,
                            controller: searchController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary,width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary,width: 2),
                              ),
                              hintText: "Rechercher",
                              hintStyle: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if(isSearching){
                                    setState(() {
                                      searchController.text = "";
                                    });
                                  }
                                },
                                child: Icon(IconlyLight.closeSquare, size: 20,color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Text("Rechercher par",style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 16,fontWeight: FontWeight.bold)),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                            showSearchCriteria(context)
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if(isSearching && searchController.text.isNotEmpty){
                  searchNewsByCriteria();
                  setState(() {
                    query = searchController.text;
                    searchController.text = "";
                  });
                } else {
                  setState(() {
                    isSearching = !isSearching;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Ionicons.search,color: Theme.of(context).colorScheme.secondary,size: 30),
              ),
            ),
          ],
        ),
      ),
      body: SmartRefresher(
        controller: refreshController,
        onRefresh: onRefresh,
        header: ClassicHeader(
          textStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
          releaseIcon: Icon(Ionicons.refresh_circle_outline,color: Theme.of(context).colorScheme.secondary,size: 30),
          idleIcon: Icon(Ionicons.arrow_down_circle_outline,color: Theme.of(context).colorScheme.secondary,size: 30),
          refreshingIcon: const CupertinoActivityIndicator(),
          completeIcon: Icon(Ionicons.checkmark_circle_outline,color: Theme.of(context).colorScheme.secondary,size: 30),
          failedIcon: Icon(Ionicons.close_circle_outline,color: Theme.of(context).colorScheme.secondary,size: 30),
          releaseText: "",
          refreshingText: "",
          completeText: "",
          idleText: "",
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if(!isSearching)
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text("sources",style: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 26,fontFamily: GoogleFonts.pacifico().fontFamily)),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sourceList.length,
                        itemBuilder: (context, index) {
                                                    
                          final Source source = sourceList[index];
                          final bool isSelected = checkIsSourceSelected(source);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                sourceSelected = source;
                                initializeNewsBySource(source);
                              });
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              color: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondaryVariant,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                child: Text(source.name,style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.secondaryVariant : Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold,fontSize: 14)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: showDynamicTitle(),
                ),
              ),
              ListView.builder(
                itemCount: newsList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
      
                  final News news = newsList[index];
      
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, SlideTopRoute(page: NewsDetailScreen(news: news)));
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: Theme.of(context).colorScheme.secondaryVariant,
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
                                  LikeButton(
                                    onTap: (bool isLiked) => onSaveButtonTapped(news,index),
                                    size: 25,
                                    circleColor: CircleColor(
                                      start: Theme.of(context).colorScheme.secondaryVariant, 
                                      end: Theme.of(context).colorScheme.secondary
                                    ),
                                    bubblesColor: BubblesColor(
                                      dotPrimaryColor: Theme.of(context).colorScheme.secondary,
                                      dotSecondaryColor: Theme.of(context).colorScheme.secondary,
                                    ),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        newsSaveList[index] ? IconlyBold.bookmark : IconlyLight.bookmark,
                                        color: Theme.of(context).colorScheme.secondary,
                                        size: 25,
                                      );
                                    }
                                  ),
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
      ),
    );
  }
}