import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:simple_news_app/screens/news_screen.dart';
import 'package:simple_news_app/screens/save_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBarItemTap(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.fastOutSlowIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: const <Widget>[NewsScreen(), SaveScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Theme.of(context).primaryColor,
        fixedColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        onTap: _onBarItemTap,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "News",
            icon: Icon(_selectedIndex == 0 ? Ionicons.newspaper : Ionicons.newspaper_outline),
          ),
          BottomNavigationBarItem(
            label: "Sauvegarder",
            icon: Icon(_selectedIndex == 0 ? IconlyLight.bookmark : IconlyBold.bookmark),
          ),
        ],
      ),
    );
  }
}
