import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode selectedThemeMode = ThemeMode.system;
  MaterialColor selectedColor = Colors.deepPurple;
  ThemeProvider() {
    refreshTheme();
  }
  refreshTheme() async {
    //load theme from shared preferences
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool? isDark = sp.getBool("isDark");
    switch (isDark) {
      case true:
        selectedThemeMode = ThemeMode.dark;
        break;
      case false:
        selectedThemeMode = ThemeMode.light;
        break;
      default:
        selectedThemeMode = ThemeMode.system;
    }
    int? savedColor = sp.getInt("savedColor");
    if (savedColor == null) {
      selectedColor = Colors.deepPurple;
    } else {
      for (var co in colorList) {
        if (savedColor == co.value) {
          selectedColor = co;
          break;
        }
      }
    }
    notifyListeners();
  }

  toggleTheme(ThemeMode themeMode) async {
    selectedThemeMode = themeMode;
    SharedPreferences sp = await SharedPreferences.getInstance();
    switch (themeMode) {
      case ThemeMode.dark:
        sp.setBool("isDark", true);
        break;
      case ThemeMode.light:
        sp.setBool("isDark", false);
        break;
      default:
        sp.remove("isDark");
    }
    notifyListeners();
  }

  toggleColor(MaterialColor color) async {
    selectedColor = color;
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt("savedColor", color.value);
    notifyListeners();
  }

  List<MaterialColor> colorList = [
    Colors.amber,
    Colors.blue,
    Colors.blueGrey,
    Colors.brown,
    Colors.cyan,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.green,
    Colors.grey,
    Colors.indigo,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.lime,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.yellow,
  ];
}
