import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:novel_app/consts.dart';
import 'package:novel_app/pages/settings_page.dart';
import 'package:novel_app/pages/story_page.dart';
import 'package:novel_app/pages/submit_page.dart';
import 'package:novel_app/providers/content_provider.dart';
import 'package:novel_app/providers/local_provider.dart';
import 'package:novel_app/providers/saved_data.dart';
import 'package:novel_app/providers/reading.dart';
import 'package:novel_app/providers/theme_provider.dart';
import 'package:novel_app/state_manager.dart';
import 'package:provider/provider.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      // apiKey: "AIzaSyCuCjsAonzEFKfdT6RueEnvo8C-it97hqA",
      // authDomain: "novel-app-1.firebaseapp.com",
      // projectId: "novel-app-1",
      // storageBucket: "novel-app-1.appspot.com",
      // messagingSenderId: "639413996910",
      // appId: "1:639413996910:web:e7992c7f27f5dc86df457f"

      apiKey: "AIzaSyAM9Fzs_tKzRYf2RoR1VRcpQvyKRO3-m0Y",
      authDomain: "novel-c00ac.firebaseapp.com",
      projectId: "novel-c00ac",
      storageBucket: "novel-c00ac.appspot.com",
      messagingSenderId: "277214592930",
      appId: "1:277214592930:web:769293a04d64a2e01afcfb",
      measurementId: "G-K8Z4653NGM",
    ),
  );
  debugPrint("Background Message: ${message.toString()}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCuCjsAonzEFKfdT6RueEnvo8C-it97hqA",
        authDomain: "novel-app-1.firebaseapp.com",
        projectId: "novel-app-1",
        storageBucket: "novel-app-1.appspot.com",
        messagingSenderId: "639413996910",
        appId: "1:639413996910:web:e7992c7f27f5dc86df457f"

        // apiKey: "AIzaSyAM9Fzs_tKzRYf2RoR1VRcpQvyKRO3-m0Y",
        // authDomain: "novel-c00ac.firebaseapp.com",
        // projectId: "novel-c00ac",
        // storageBucket: "novel-c00ac.appspot.com",
        // messagingSenderId: "277214592930",
        // appId: "1:277214592930:web:769293a04d64a2e01afcfb",
        // measurementId: "G-K8Z4653NGM",
        ),
  );
  debugPrint(await FirebaseMessaging.instance.getToken());
  FirebaseMessaging.instance.onTokenRefresh.listen((event) {
    debugPrint("Token Refreshed: $event");
  });
  FirebaseMessaging.onMessage.listen((event) {
    debugPrint("Foreground Message: ${event.toString()}");
  });
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  await FirebaseMessaging.instance.subscribeToTopic("news");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ContentProvider>(create: (_) => ContentProvider()),
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ChangeNotifierProvider<LocalProvider>(create: (_) => LocalProvider()),
      ChangeNotifierProvider<Reading>(create: (_) => Reading()),
      ChangeNotifierProvider<SavedData>(create: (_) => SavedData()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      locale: Provider.of<LocalProvider>(context).selectedLocal ?? defaultLocal,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: "Cairo",
        colorSchemeSeed: Provider.of<ThemeProvider>(context).selectedColor,
        useMaterial3: true,
        splashColor:
            Provider.of<ThemeProvider>(context).selectedColor.withOpacity(.2),
        highlightColor:
            Provider.of<ThemeProvider>(context).selectedColor.withOpacity(.2),
        iconTheme: IconThemeData(
            color: Provider.of<ThemeProvider>(context).selectedColor),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Cairo",
        colorSchemeSeed: Provider.of<ThemeProvider>(context).selectedColor,
        useMaterial3: true,
        splashColor:
            Provider.of<ThemeProvider>(context).selectedColor.withOpacity(.2),
        highlightColor:
            Provider.of<ThemeProvider>(context).selectedColor.withOpacity(.2),
        iconTheme: IconThemeData(
            color: Provider.of<ThemeProvider>(context).selectedColor),
      ),
      themeMode: Provider.of<ThemeProvider>(context).selectedThemeMode,
      supportedLocales: [
        Locale("en", "US"),
        Locale('ar', 'SA'),
      ],
      routes: {
        "/": (context) => StateManager(),
        StoryPage.routeName: (context) => Theme(
              data: Theme.of(context).copyWith(
                  textTheme:
                      Theme.of(context).textTheme.apply(fontFamily: 'Noto')),
              child: StoryPage(),
            ),
        SettingsPage.routeName: (context) => SettingsPage(),
        SubmitPage.routeName: (context) => SubmitPage(),
      },
      initialRoute: "/",
    );
  }
}
