import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:novel_controlpanel/pages/components/func.dart';
import 'package:novel_controlpanel/pages/tabs/profile_tab.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  //final AppBar appBar;
  final String title;
  const MyAppBar(
      {Key? key,
      //required this.appBar,
      required this.title})
      : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  late bool isProtrait;

  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);
    return AppBar(
      automaticallyImplyLeading: true,
      foregroundColor: Colors.white,
      title: Text(widget.title),
      actions: [
        PopupMenuButton<int>(
          tooltip: "خيارات",
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Text("الملف الشخصي"),
                    Spacer(),
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                    )
                  ],
                )),
            PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Text("تسجيل خروج"),
                    Spacer(),
                    Icon(
                      Icons.logout,
                      color: Colors.grey,
                    )
                  ],
                )),
          ],
          onSelected: (x) async {
            if (x == 1) {
              await FirebaseAuth.instance.signOut();
              if (!mounted) {
                return;
              }
              Navigator.of(context).pushReplacementNamed("/");
            }
            if (x == 0) {
              if (!mounted) {
                return;
              }
              Navigator.pushReplacementNamed(context, ProfileTab.routeName);
            }
          },
          elevation: 0,
          child: isProtrait
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 8),
                    CircleAvatar(
                      foregroundImage:
                          FirebaseAuth.instance.currentUser?.photoURL == null
                              ? null
                              : NetworkImage(
                                  FirebaseAuth.instance.currentUser!.photoURL!),
                    ),
                    SizedBox(width: 8),
                    Text(FirebaseAuth.instance.currentUser?.displayName ??
                        FirebaseAuth.instance.currentUser?.email
                            ?.split("@")
                            .first ??
                        "غير معروف"),
                    Icon(Icons.arrow_drop_down),
                    SizedBox(width: 8),
                  ],
                ),
        ),
      ],
    );
  }
}
