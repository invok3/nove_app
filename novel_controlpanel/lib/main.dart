import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:novel_controlpanel/consts.dart';
import 'package:novel_controlpanel/pages/tabs/about_tab.dart';
import 'package:novel_controlpanel/pages/tabs/categories_tab.dart';
import 'package:novel_controlpanel/pages/tabs/edit_category_tab.dart';
import 'package:novel_controlpanel/pages/tabs/edit_story_tab.dart';
import 'package:novel_controlpanel/pages/tabs/messages_tab.dart';
import 'package:novel_controlpanel/pages/tabs/notification_tab.dart';
import 'package:novel_controlpanel/pages/tabs/preview_page.dart';
import 'package:novel_controlpanel/pages/tabs/profile_tab.dart';
import 'package:novel_controlpanel/pages/tabs/stories_tab.dart';
import 'package:novel_controlpanel/providers/user_provider.dart';
import 'package:novel_controlpanel/state_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCuCjsAonzEFKfdT6RueEnvo8C-it97hqA",
      authDomain: "novel-app-1.firebaseapp.com",
      projectId: "novel-app-1",
      storageBucket: "novel-app-1.appspot.com",
      messagingSenderId: "639413996910",
      appId: "1:639413996910:web:e7992c7f27f5dc86df457f",

      // apiKey: "AIzaSyAM9Fzs_tKzRYf2RoR1VRcpQvyKRO3-m0Y",
      // authDomain: "novel-c00ac.firebaseapp.com",
      // projectId: "novel-c00ac",
      // storageBucket: "novel-c00ac.appspot.com",
      // messagingSenderId: "277214592930",
      // appId: "1:277214592930:web:769293a04d64a2e01afcfb",
      // measurementId: "G-K8Z4653NGM",
    ),
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      locale: Locale('ar', 'SA'),
      supportedLocales: [
        Locale('ar', 'SA'),
      ],
      color: kPrimary,
      theme: ThemeData(primaryColor: kPrimary, primarySwatch: kPrimary),
      darkTheme: ThemeData(primaryColor: kPrimary, primarySwatch: kPrimary),
      debugShowCheckedModeBanner: false,
      //showPerformanceOverlay: true,
      routes: {
        "/": (context) => StateManager(),
        CategoriesTab.routeName: (context) => CategoriesTab(),
        EditCategoryTab.routeName: (context) => EditCategoryTab(),
        EditStoryTab.routeName: (context) => EditStoryTab(),
        ProfileTab.routeName: (context) => ProfileTab(),
        StoriesTab.routeName: (context) => StoriesTab(),
        PreviewPage.routeName: (context) => PreviewPage(),
        AboutTab.routeName: (context) => AboutTab(),
        MessagesTab.routeName: (context) => MessagesTab(),
        NotificationTab.routeName: (context) => NotificationTab()
      },
      initialRoute: "/",
    );
  }
}
