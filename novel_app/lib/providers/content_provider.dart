import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:novel_app/controllers/firebase_api.dart';

class ContentProvider extends ChangeNotifier {
  bool content = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? categories;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? stories;

  ContentProvider() {
    refreshContent();
  }

  Future<void> refreshContent() async {
    content = false;
    categories = null;
    stories = null;
    notifyListeners();
    categories = await FirebaseAPI.fetchCats();
    stories = await FirebaseAPI.fetchStories();
    content = true;
    notifyListeners();
  }
}
