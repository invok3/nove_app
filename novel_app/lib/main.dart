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
    options: const FirebaseOptions(
        apiKey: "AIzaSyBNnu0cZqKT8Tx4rTjMRNHmgRJOPmjAaPE",
        authDomain: "novel-app-f1572.firebaseapp.com",
        projectId: "novel-app-f1572",
        storageBucket: "novel-app-f1572.appspot.com",
        messagingSenderId: "521139126077",
        appId: "1:521139126077:web:ca6acb277d1e785b800f54",
        measurementId: "G-Q5EYTB38B9"),
  );
  debugPrint("Background Message: ${message.toString()}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
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
      supportedLocales: const [
        Locale("en", "US"),
        Locale('ar', 'SA'),
      ],
      routes: {
        "/": (context) => const StateManager(),
        StoryPage.routeName: (context) => Theme(
              data: Theme.of(context).copyWith(
                  textTheme:
                      Theme.of(context).textTheme.apply(fontFamily: 'Noto')),
              child: const StoryPage(),
            ),
        SettingsPage.routeName: (context) => const SettingsPage(),
        SubmitPage.routeName: (context) => const SubmitPage(),
      },
      initialRoute: "/",
    );
  }
}
