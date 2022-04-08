import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedData extends ChangeNotifier {
  bool loaded = false;
  List<String> favoriteStories = [];
  List<String> favoriteCategories = [];
  Map<String, String?> bookmarked = {"catID": null, "storyID": null};
  SavedData() {
    loadSavedData();
  }
  loadSavedData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    favoriteCategories = sp.getStringList("favoriteCategories") ?? [];
    favoriteStories = sp.getStringList("favoriteStories") ?? [];
    bookmarked = {
      "catID": sp.getString("bookmarked.catID"),
      "storyID": sp.getString("bookmarked.storyID"),
    };
    loaded = true;
    notifyListeners();
  }

  saveData({required String data, required String list}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> oList = sp.getStringList(list) ?? [];
    oList.add(data);
    await sp.setStringList(list, oList);
    list == "favoriteCategories"
        ? favoriteCategories = oList
        : favoriteStories = oList;
    notifyListeners();
  }

  removeData({required String data, required String list}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> oList = sp.getStringList(list) ?? [];
    oList.remove(data);
    await sp.setStringList(list, oList);
    list == "favoriteCategories"
        ? favoriteCategories = oList
        : favoriteStories = oList;
    notifyListeners();
  }

  bookmark({String? catID, String? storyID}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (catID == null || storyID == null) {
      await sp.remove("bookmarked.catID");
      await sp.remove("bookmarked.storyID");
    } else {
      await sp.setString("bookmarked.catID", catID);
      await sp.setString("bookmarked.storyID", storyID);
    }
    bookmarked = {"catID": catID, "storyID": storyID};
    notifyListeners();
  }

  bool isFavoriteStory(String? storyID) {
    if (storyID == null) {
      return false;
    } else {
      for (String isFavorite in favoriteStories) {
        if (isFavorite == storyID) {
          return true;
        }
      }
      return false;
    }
  }
}
