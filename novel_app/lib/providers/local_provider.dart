import 'package:flutter/material.dart';
import 'package:novel_app/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalProvider extends ChangeNotifier {
  Locale? selectedLocal;
  LocalProvider() {
    refreshLocal();
  }
  refreshLocal() async {
    //load local from shared preferences
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? savedLocale = sp.getString("savedLocale");
    switch (savedLocale) {
      case "ar":
        selectedLocal = const Locale("ar", "SA");
        break;
      case "en":
        selectedLocal = const Locale("en", "US");
        break;
      default:
        selectedLocal = defaultLocal;
    }
    notifyListeners();
  }

  toggleLocale(Locale locale) async {
    selectedLocal = locale;
    //save to sp
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("savedLocale", locale.languageCode);
    notifyListeners();
  }
}
