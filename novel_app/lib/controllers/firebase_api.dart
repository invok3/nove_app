import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class FirebaseAPI {
  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchCats() async {
    try {
      QuerySnapshot<Map<String, dynamic>> cats =
          await FirebaseFirestore.instance.collection("categories").get();
      return cats.docs;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchStories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> stories =
          await FirebaseFirestore.instance.collection("stories").get();
      return stories.docs;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<String> submit(
      {required String name,
      required String email,
      required String subject,
      required String content}) async {
    try {
      await FirebaseFirestore.instance.collection("suggestions").doc().set({
        "name": name,
        "email": email,
        "subject": subject,
        "content": content,
      });
      return "Done";
    } catch (e) {
      //e as FirebaseException;
      debugPrint(e.toString());
      return "Error: $e";
    }
  }

  static Future<String?> getAboutDoc() async {
    try {
      var docLimit = await FirebaseFirestore.instance.collection("about").get();
      var doc = docLimit.docs.last;
      return doc["document"];
    } catch (e) {
      debugPrint("FirebaseAPI.getAboutDoc: $e");
      return null;
    }
  }
}
