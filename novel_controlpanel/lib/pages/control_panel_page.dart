import 'package:flutter/material.dart';
import 'package:novel_controlpanel/controllers/firebase_api.dart';
import 'package:novel_controlpanel/pages/components/appbar.dart';
import 'package:novel_controlpanel/pages/components/drawer_listview.dart';
import 'package:novel_controlpanel/pages/components/flex_sidebar.dart';
import 'package:novel_controlpanel/pages/components/func.dart';
import 'package:novel_controlpanel/pages/tabs/categories_tab.dart';
import 'package:novel_controlpanel/pages/tabs/stories_tab.dart';

class ControlPanelPage extends StatefulWidget {
  const ControlPanelPage({Key? key}) : super(key: key);

  @override
  State<ControlPanelPage> createState() => ControlPanelPageState();
}

class ControlPanelPageState extends State<ControlPanelPage> {
  late bool isProtrait;

  int catsLengths = 0;

  int storiesLength = 0;

  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);

    return Scaffold(
      drawer: isProtrait
          ? Drawer(
              child: MyDrawerListView(drawer: true),
              //backgroundColor: Colors.grey[800],
            )
          : null,
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "لوحة التحكم",
      ),
      body: SafeArea(
        child: FlexSideBar(
          isProtrait: isProtrait,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: isProtrait
                        ? _children(catsLengths, storiesLength)
                        : [
                            Row(
                              children: _children(catsLengths, storiesLength),
                            )
                          ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _children(int _catsLength, int _storiesLength) {
    return [
      Card(
        clipBehavior: Clip.hardEdge,
        elevation: 10,
        shadowColor: Colors.amber,
        color: Colors.amber,
        child: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, CategoriesTab.routeName);
          },
          child: SizedBox(
            width: 250,
            height: 120,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "عدد الأجزاء",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            _catsLength.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          )
                        ],
                      ),
                      Icon(
                        Icons.list_alt,
                        color: Colors.white.withOpacity(.3),
                        size: 56,
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey.withOpacity(.4),
                  child: Row(
                    children: [
                      Spacer(flex: 1),
                      Text(
                        "الأجزاء",
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(flex: 8),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      ),
                      Spacer(flex: 1)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Card(
        clipBehavior: Clip.hardEdge,
        elevation: 10,
        shadowColor: Colors.orange,
        color: Colors.orange,
        child: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, StoriesTab.routeName);
          },
          child: SizedBox(
            width: 250,
            height: 120,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "عدد الحلقات",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            _storiesLength.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          )
                        ],
                      ),
                      Icon(
                        Icons.list,
                        color: Colors.white.withOpacity(.3),
                        size: 56,
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey.withOpacity(.4),
                  child: Row(
                    children: [
                      Spacer(flex: 1),
                      Text(
                        "الحلقات",
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(flex: 8),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      ),
                      Spacer(flex: 1)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Future<void> fetchData() async {
    if (loaded) {
      return;
    }
    var cats = await FirebaseAPI.fetchCats();
    var stories = await FirebaseAPI.fetchStories();
    setState(() {
      loaded = true;
      catsLengths = cats.length;
      storiesLength = stories.length;
    });
    return;
  }
}
