import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:novel_controlpanel/controllers/firebase_api.dart';
import 'package:novel_controlpanel/pages/components/func.dart';
import 'package:novel_controlpanel/pages/tabs/about_tab.dart';
import 'package:novel_controlpanel/pages/tabs/categories_tab.dart';
import 'package:novel_controlpanel/pages/tabs/messages_tab.dart';
import 'package:novel_controlpanel/pages/tabs/notification_tab.dart';
import 'package:novel_controlpanel/pages/tabs/profile_tab.dart';
import 'package:novel_controlpanel/pages/tabs/stories_tab.dart';

class MyDrawerListView extends StatefulWidget {
  final bool drawer;
  const MyDrawerListView({Key? key, required this.drawer}) : super(key: key);

  @override
  State<MyDrawerListView> createState() => _MyDrawerListViewState();
}

class _MyDrawerListViewState extends State<MyDrawerListView> {
  late bool isProtrait;

  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);
    bool drawer = widget.drawer;
    return ListView(
      children: [
        drawer
            ? Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: _getRad(),
                      foregroundImage:
                          FirebaseAuth.instance.currentUser?.photoURL == null
                              ? null
                              : NetworkImage(
                                  FirebaseAuth.instance.currentUser!.photoURL!),
                    ),
                    Text(FirebaseAuth.instance.currentUser?.displayName ??
                        FirebaseAuth.instance.currentUser?.email
                            ?.split("@")
                            .first ??
                        "غير معروف"),
                  ],
                ),
              )
            : Container(),
        isProtrait ? Divider() : Container(),
        ListTile(
          onTap: () => Navigator.pushReplacementNamed(context, "/"),
          textColor: drawer ? null : Colors.white,
          iconColor: drawer ? null : Colors.white,
          leading: Icon(Icons.computer),
          title: Text("الصفحة الرئيسية"),
        ),
        ListTile(
          onTap: () =>
              Navigator.pushReplacementNamed(context, CategoriesTab.routeName),
          textColor: drawer ? null : Colors.white,
          iconColor: drawer ? null : Colors.white,
          leading: Icon(Icons.list_alt),
          title: Text("الأجزاء"),
        ),
        ListTile(
          onTap: () =>
              Navigator.pushReplacementNamed(context, StoriesTab.routeName),
          textColor: drawer ? null : Colors.white,
          iconColor: drawer ? null : Colors.white,
          leading: Icon(Icons.list),
          title: Text("الحلقات"),
        ),
        ListTile(
          onTap: () => Navigator.pushReplacementNamed(
              context, NotificationTab.routeName),
          textColor: drawer ? null : Colors.white,
          iconColor: drawer ? null : Colors.white,
          leading: Icon(Icons.notifications),
          title: Text("إشعارات"),
        ),
        ListTile(
          onTap: () =>
              Navigator.pushReplacementNamed(context, MessagesTab.routeName),
          textColor: drawer ? null : Colors.white,
          iconColor: drawer ? null : Colors.white,
          leading: Icon(Icons.mail),
          title: Text("الشكاوي و الإقتراحات"),
        ),
        ListTile(
          onTap: () async {
            String docString = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: FutureBuilder(
                  future: FirebaseAPI.loadAbout(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      );
                    } else {
                      Navigator.pop(context, snapshot.data.toString());
                      return SizedBox();
                    }
                  },
                ),
              ),
            );
            if (!mounted) {
              return;
            }
            Navigator.pushNamed(context, AboutTab.routeName,
                arguments: docString);
          },
          textColor: drawer ? null : Colors.white,
          iconColor: drawer ? null : Colors.white,
          leading: Icon(Icons.hail),
          title: Text("عن الكاتب"),
        ),
        ListTile(
          onTap: () =>
              Navigator.pushReplacementNamed(context, ProfileTab.routeName),
          textColor: drawer ? null : Colors.white,
          iconColor: drawer ? null : Colors.white,
          leading: Icon(Icons.person),
          title: Text("الملف الشخصي"),
        ),
      ],
    );
  }

  _getRad() {
    double x = MediaQuery.of(context).size.width / 6;
    double y = MediaQuery.of(context).size.height / 10;
    return x < y ? x : y;
  }
}
