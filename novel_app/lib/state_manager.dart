import 'package:flutter/material.dart';
import 'package:novel_app/pages/about_page.dart';
import 'package:novel_app/pages/categories_page.dart';
import 'package:novel_app/pages/favorite_page.dart';
import 'package:novel_app/pages/settings_page.dart';
import 'package:novel_app/pages/stories_page.dart';
import 'package:novel_app/pages/story_page.dart';
import 'package:novel_app/providers/reading.dart';
import 'package:novel_app/providers/saved_data.dart';
import 'package:novel_app/providers/theme_provider.dart';
import 'package:novel_app/translate/translator.dart';
import 'package:provider/provider.dart';

class StateManager extends StatefulWidget {
  const StateManager({Key? key}) : super(key: key);

  @override
  State<StateManager> createState() => StateManagerState();
}

class StateManagerState extends State<StateManager> {
  late List<Map<String, dynamic>> tabs;
  int selectedNavBarItem = 0;
  GlobalKey<State<BottomNavigationBar>> botNavBarKey = GlobalKey();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    tabs = returnTabs();
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height * 2,
            ),
            Expanded(
                child: ListView(
              children: [
                ListTile(
                  iconColor: Provider.of<ThemeProvider>(context).selectedColor,
                  textColor: Provider.of<ThemeProvider>(context).selectedColor,
                  title: Text(Translator.of(context, "aboutAuthor")),
                  leading: Icon(Icons.hail_outlined),
                  onTap: () {
                    _key.currentState!.isDrawerOpen
                        ? Navigator.pop(context)
                        : null;
                    (botNavBarKey.currentWidget as BottomNavigationBar)
                        .onTap!(2);
                  },
                ),
                ListTile(
                  iconColor: Provider.of<ThemeProvider>(context).selectedColor,
                  textColor: Provider.of<ThemeProvider>(context).selectedColor,
                  title: Text(Translator.of(context, "chaptersLabel")),
                  leading: Icon(Icons.book_outlined),
                  onTap: () {
                    _key.currentState!.isDrawerOpen
                        ? Navigator.pop(context)
                        : null;
                    (botNavBarKey.currentWidget as BottomNavigationBar)
                        .onTap!(0);
                  },
                ),
                ListTile(
                  iconColor: Provider.of<ThemeProvider>(context).selectedColor,
                  textColor: Provider.of<ThemeProvider>(context).selectedColor,
                  title: Text(Translator.of(context, "episodesLabel")),
                  leading: Icon(Icons.menu_book_outlined),
                  onTap: () {
                    _key.currentState!.isDrawerOpen
                        ? Navigator.pop(context)
                        : null;
                    (botNavBarKey.currentWidget as BottomNavigationBar)
                        .onTap!(1);
                    Provider.of<Reading>(context, listen: false).setCatID(null);
                  },
                ),
                ListTile(
                  iconColor: Provider.of<ThemeProvider>(context).selectedColor,
                  textColor: Provider.of<ThemeProvider>(context).selectedColor,
                  title: Text(Translator.of(context, "favoriteLabel")),
                  leading: Icon(Icons.favorite_border),
                  onTap: () {
                    _key.currentState!.isDrawerOpen
                        ? Navigator.pop(context)
                        : null;
                    (botNavBarKey.currentWidget as BottomNavigationBar)
                        .onTap!(3);
                  },
                ),
                ListTile(
                  iconColor: Provider.of<ThemeProvider>(context).selectedColor,
                  textColor: Provider.of<ThemeProvider>(context).selectedColor,
                  title: Text(Translator.of(context, "bookmarkLabel")),
                  leading: Icon(Icons.bookmark_border),
                  onTap: () {
                    _key.currentState!.isDrawerOpen
                        ? Navigator.pop(context)
                        : null;
                    if (Provider.of<SavedData>(context, listen: false)
                            .bookmarked["storyID"] ==
                        null) {
                      return;
                    } else {
                      Provider.of<Reading>(context, listen: false).setCatID(
                          Provider.of<SavedData>(context, listen: false)
                              .bookmarked["catID"]);
                      Provider.of<Reading>(context, listen: false).setStoryID(
                          Provider.of<SavedData>(context, listen: false)
                              .bookmarked["storyID"]);
                      (botNavBarKey.currentWidget as BottomNavigationBar)
                          .onTap!(1);
                      Navigator.pushNamed(context, StoryPage.routeName);
                    }
                  },
                ),
                ListTile(
                  iconColor: Provider.of<ThemeProvider>(context).selectedColor,
                  textColor: Provider.of<ThemeProvider>(context).selectedColor,
                  title: Text(Translator.of(context, "Settings")),
                  leading: Icon(Icons.settings_outlined),
                  onTap: () {
                    _key.currentState!.isDrawerOpen
                        ? Navigator.pop(context)
                        : null;
                    Navigator.pushNamed(context, SettingsPage.routeName);
                  },
                ),
              ],
            )),
          ],
        ),
      ),
      key: _key,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _key.currentState!.openDrawer();
                    },
                    icon: Icon(
                      Icons.menu,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SettingsPage.routeName);
                    },
                    icon: Icon(
                      Icons.settings,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: tabs[selectedNavBarItem]["widget"],
            )
          ],
        ),
      ),
      //Backup

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Provider.of<ThemeProvider>(context).selectedColor,
                blurRadius: 6,
                spreadRadius: -2,
                offset: Offset(0, 0))
          ],
          color: Theme.of(context).canvasColor,
        ),
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                  mainAxisSize: MainAxisSize.max,
                  children: tabs
                      .map((e) => Flexible(
                              child: SizedBox(
                            // duration: Duration(milliseconds: 250),
                            height: 4,
                            //color: kPrimaryColor,
                            child: Row(
                              children: [
                                Flexible(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 250),
                                    height: selectedNavBarItem == e['index']
                                        ? 4
                                        : 0,
                                    color: Provider.of<ThemeProvider>(context)
                                        .selectedColor,
                                    child: Row(),
                                  ),
                                ),
                              ],
                            ),
                          )))
                      .toList()),
              BottomNavigationBar(
                backgroundColor: Colors.transparent,
                selectedItemColor:
                    Provider.of<ThemeProvider>(context).selectedColor,
                elevation: 0,
                key: botNavBarKey,
                currentIndex: selectedNavBarItem,
                onTap: (s) {
                  reAnimate(s);
                  if (s != 1) {
                    Provider.of<Reading>(context, listen: false).setCatID(null);
                  }
                },
                type: BottomNavigationBarType.fixed,
                // showSelectedLabels: false,
                // showUnselectedLabels: false,
                items: _navBarItems(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> returnTabs() {
    return [
      {
        "label": Translator.of(context, "chaptersLabel"),
        "icon": Icon(selectedNavBarItem == 0 ? Icons.book : Icons.book_outlined,
            color: selectedNavBarItem == 0
                ? Provider.of<ThemeProvider>(context).selectedColor
                : Colors.grey),
        "widget": CategoriesPage(bnbk: botNavBarKey),
        "index": 0,
      },
      {
        "label": Translator.of(context, "episodesLabel"),
        "icon": Icon(
            selectedNavBarItem == 1
                ? Icons.menu_book
                : Icons.menu_book_outlined,
            color: selectedNavBarItem == 1
                ? Provider.of<ThemeProvider>(context).selectedColor
                : Colors.grey),
        "widget": StoriesPage(),
        "index": 1,
      },
      {
        "label": Translator.of(context, "aboutAuthor"),
        "icon": Icon(selectedNavBarItem == 2 ? Icons.hail : Icons.hail_outlined,
            color: selectedNavBarItem == 2
                ? Provider.of<ThemeProvider>(context).selectedColor
                : Colors.grey),
        "widget": AboutPage(),
        "index": 2,
      },
      {
        "label": Translator.of(context, "favoriteLabel"),
        "icon": Icon(
            selectedNavBarItem == 3 ? Icons.favorite : Icons.favorite_outline,
            color: selectedNavBarItem == 3
                ? Provider.of<ThemeProvider>(context).selectedColor
                : Colors.grey),
        "widget": FavoritePage(bnbk: botNavBarKey),
        "index": 3,
        "badgeScore": "300",
      },
    ];
  }

  void reAnimate(int x) {
    setState(() {
      selectedNavBarItem = x;
    });
  }

  List<BottomNavigationBarItem> _navBarItems() {
    return tabs
        .map((e) => BottomNavigationBarItem(
              icon: e['icon'] as Icon,
              label: e['label'] as String,
            ))
        .toList();
  }
}
