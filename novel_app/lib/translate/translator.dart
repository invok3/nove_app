import 'package:flutter/material.dart';
import 'package:novel_app/consts.dart';
import 'package:novel_app/providers/local_provider.dart';
import 'package:novel_app/translate/translation.dart';
import 'package:provider/provider.dart';

abstract class Translator {
  static String of(BuildContext context, String word) {
    return x[Provider.of<LocalProvider>(context).selectedLocal?.languageCode ??
            defaultLocal.languageCode]?[word] ??
        "Unknown Translation!";
  }
}
