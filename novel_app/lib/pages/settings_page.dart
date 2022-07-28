import 'package:flutter/material.dart';
import 'package:novel_app/consts.dart';
import 'package:novel_app/pages/submit_page.dart';
import 'package:novel_app/providers/local_provider.dart';
import 'package:novel_app/providers/theme_provider.dart';
import 'package:novel_app/translate/translator.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  static String routeName = "/SettingsPage";
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  const Spacer(),
                  Text(
                    Translator.of(context, "Settings"),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color:
                            Provider.of<ThemeProvider>(context).selectedColor),
                  ),
                  const Spacer(),
                  const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.transparent,
                      )),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () => _selectLanguage(),
                    leading: const Icon(Icons.language),
                    title: Text(Translator.of(context, "Language")),
                    subtitle: Text(
                        (Provider.of<LocalProvider>(context).selectedLocal ??
                                        defaultLocal)
                                    .languageCode ==
                                "en"
                            ? "English"
                            : "العربية"),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                  ),
                  ListTile(
                    onTap: () => _selectTheme(),
                    leading: const Icon(Icons.light_mode),
                    title: Text(Translator.of(context, "ThemeMode")),
                    subtitle: Text(
                        Provider.of<ThemeProvider>(context).selectedThemeMode ==
                                ThemeMode.system
                            ? Translator.of(context, "Default")
                            : Provider.of<ThemeProvider>(context)
                                        .selectedThemeMode ==
                                    ThemeMode.dark
                                ? Translator.of(context, "Dark")
                                : Translator.of(context, "Light")),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                  ),
                  ListTile(
                    onTap: () => _selectColor(),
                    leading: const Icon(Icons.colorize),
                    title: Text(Translator.of(context, "Color")),
                    subtitle: Text(Translator.of(context, "ThemeColor")),
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Provider.of<ThemeProvider>(context)
                              .selectedColor),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: Text(Translator.of(context, "ShareTitle")),
                    subtitle: Text(Translator.of(context, "ShareAppText")),
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_rate),
                    title: Text(Translator.of(context, "rateUsTitle")),
                  ),
                  ListTile(
                    onTap: () =>
                        Navigator.pushNamed(context, SubmitPage.routeName),
                    leading: const Icon(Icons.email),
                    title: Text(Translator.of(context, "contactUsTitle")),
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: Text(Translator.of(context, "privacyPolicyTitle")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectLanguage() async {
    Locale? locale = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(MediaQuery.of(context).size.width / 4),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () => Navigator.pop(context, const Locale("en", "US")),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("English"),
                ],
              ),
            ),
            ListTile(
              onTap: () => Navigator.pop(context, const Locale("ar", "SA")),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("العربية"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (!mounted) {
      return;
    }
    locale != null
        ? Provider.of<LocalProvider>(context, listen: false)
            .toggleLocale(locale)
        : null;
  }

  _selectTheme() async {
    ThemeMode? x = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(MediaQuery.of(context).size.width / 4),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () => Navigator.pop(context, ThemeMode.system),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Translator.of(context, "Default")),
                ],
              ),
            ),
            ListTile(
              onTap: () => Navigator.pop(context, ThemeMode.light),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Translator.of(context, "Light")),
                ],
              ),
            ),
            ListTile(
              onTap: () => Navigator.pop(context, ThemeMode.dark),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Translator.of(context, "Dark")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (x == null) {
      return;
    } else {
      if (!mounted) {
        return;
      }
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme(x);
    }
  }

  _selectColor() async {
    MaterialColor? color = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorCircle(context, Colors.amber),
                colorCircle(context, Colors.blue),
                colorCircle(context, Colors.blueGrey),
                colorCircle(context, Colors.brown),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorCircle(context, Colors.cyan),
                colorCircle(context, Colors.deepOrange),
                colorCircle(context, Colors.deepPurple),
                colorCircle(context, Colors.green),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorCircle(context, Colors.grey),
                colorCircle(context, Colors.indigo),
                colorCircle(context, Colors.lightBlue),
                colorCircle(context, Colors.lightGreen),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorCircle(context, Colors.lime),
                colorCircle(context, Colors.orange),
                colorCircle(context, Colors.pink),
                colorCircle(context, Colors.purple),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                colorCircle(context, Colors.red),
                colorCircle(context, Colors.teal),
                colorCircle(context, Colors.yellow),
              ],
            ),
          ],
        ),
      ),
    );
    if (!mounted) {
      return;
    }
    color != null
        ? Provider.of<ThemeProvider>(context, listen: false).toggleColor(color)
        : null;
  }

  InkWell colorCircle(BuildContext context, MaterialColor color) {
    return InkWell(
        onTap: () => Navigator.pop(context, color),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ));
  }
}
