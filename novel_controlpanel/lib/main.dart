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
    options: const FirebaseOptions(
        apiKey: "AIzaSyBNnu0cZqKT8Tx4rTjMRNHmgRJOPmjAaPE",
        authDomain: "novel-app-f1572.firebaseapp.com",
        projectId: "novel-app-f1572",
        storageBucket: "novel-app-f1572.appspot.com",
        messagingSenderId: "521139126077",
        appId: "1:521139126077:web:ca6acb277d1e785b800f54",
        measurementId: "G-Q5EYTB38B9"),
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
