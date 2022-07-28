import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:novel_controlpanel/controllers/firebase_api.dart';
import 'package:novel_controlpanel/pages/components/appbar.dart';
import 'package:novel_controlpanel/pages/components/drawer_listview.dart';
import 'package:novel_controlpanel/pages/components/flex_sidebar.dart';
import 'package:novel_controlpanel/pages/components/func.dart';
import 'package:novel_controlpanel/pages/tabs/edit_story_tab.dart';
import 'package:novel_controlpanel/pages/tabs/preview_page.dart';

class StoriesTab extends StatefulWidget {
  static String routeName = "/StoriesTab";

  const StoriesTab({Key? key}) : super(key: key);

  @override
  State<StoriesTab> createState() => _StoriesTabState();
}

class _StoriesTabState extends State<StoriesTab> {
  late bool isProtrait;
  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);
    double x = (MediaQuery.of(context).size.width - 250) / 5;
    double y = MediaQuery.of(context).size.height / 7;
    x = x < y ? y : x;
    return Scaffold(
      drawer: isProtrait
          ? Drawer(
              child: MyDrawerListView(drawer: true),
              //backgroundColor: Colors.grey[800],
            )
          : null,
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "الحلقات",
      ),
      body: SafeArea(
        child: FlexSideBar(
          isProtrait: isProtrait,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      String? catID = await selectCatID();
                      if (catID == null) {
                        return;
                      }
                      if (!mounted) {
                        return;
                      }
                      Navigator.pushNamed(context, EditStoryTab.routeName,
                          arguments: {"catID": catID}).then((value) {
                        setState(() {});
                      });
                    },
                    label: Text(
                      "إضافة",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              Expanded(
                child: FutureBuilder(
                  future: FirebaseAPI.fetchStories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data == null) {
                      return Center(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[700],
                          ),
                          Text(
                            "حدث خطأ اثناء التصال بقاعدة البيانات",
                            style: TextStyle(color: Colors.red[700]),
                          )
                        ],
                      ));
                    } else {
                      var mList = snapshot.data as List<Map<String, String>>;
                      return mList.isEmpty
                          ? Center(
                              child: Text("لم تقم بأضافة حلقات"),
                            )
                          : SingleChildScrollView(
                              controller: ScrollController(),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                  children: mList
                                      .map((e) => mCard(
                                            catID: e["catID"] ?? "",
                                            id: e["id"] ?? "",
                                            title: e["title"] ?? "",
                                            subtitle: e["description"],
                                            image: e["image"],
                                            document: e["document"],
                                            width: x,
                                            height: y,
                                          ))
                                      .toList()),
                            );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mCard(
      {required String id,
      required String catID,
      required String title,
      String? subtitle,
      String? image,
      String? document,
      required double width,
      required double height}) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 10,
      margin: EdgeInsets.all(8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Image.network(
          image ?? "",
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/350.png",
              height: height,
              width: width,
              fit: BoxFit.cover,
            );
          },
          fit: BoxFit.cover,
        ),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.amber,
                      ),
                ),
                Text(
                  subtitle ?? "",
                  //softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  Navigator.pushNamed(context, PreviewPage.routeName,
                      arguments: document);
                },
                child: Padding(
                  padding:
                      isProtrait ? EdgeInsets.all(4.0) : EdgeInsets.all(8.0),
                  child: Icon(Icons.phone_iphone, color: Colors.amber),
                )),
            InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(EditStoryTab.routeName, arguments: {
                    "id": id,
                    "catID": catID,
                    "title": title,
                    "subtitle": subtitle,
                    "document": document,
                    "image": image
                  }).then((value) {
                    setState(() {});
                  });
                },
                child: Padding(
                  padding:
                      isProtrait ? EdgeInsets.all(4.0) : EdgeInsets.all(8.0),
                  child: Icon(Icons.edit, color: Colors.amber),
                )),
            InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () async {
                  bool? confirmation = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text("حذف الحلقة, لا يمكن التراجع!"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text("موافق")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("رجوع")),
                            ],
                          ));
                  if (confirmation != true) {
                    return;
                  }
                  await FirebaseFirestore.instance
                      .collection("stories")
                      .doc(id)
                      .delete();
                  setState(() {});
                },
                child: Padding(
                  padding:
                      isProtrait ? EdgeInsets.all(4.0) : EdgeInsets.all(8.0),
                  child: Icon(Icons.delete, color: Colors.amber),
                )),
          ],
        ),
      ]),
    );
  }

  Future<String?> selectCatID() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: FutureBuilder(
          future: FirebaseAPI.fetchCats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data == null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text("لا يمكن العثور على أجزاء"),
                  ),
                ],
              );
            } else {
              List<Map<String, String>> mList =
                  snapshot.data as List<Map<String, String>>;
              return mList.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text("لم تقم بأضافة أجزاء بعد"),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: mList
                            .map((e) => ListTile(
                                  title: Text(e["title"].toString()),
                                  onTap: () {
                                    Navigator.pop(context, e["id"]);
                                  },
                                ))
                            .toList(),
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}
