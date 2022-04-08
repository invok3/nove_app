import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:novel_app/controllers/firebase_api.dart';
import 'package:novel_app/translate/translator.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  quill.Document? _document;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDocument(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else if (_document != null) {
          return SingleChildScrollView(
            child: quill.QuillEditor(
              controller: quill.QuillController(
                selection: TextSelection(baseOffset: 0, extentOffset: 0),
                document: _document!,
              ),
              readOnly: true,
              padding: EdgeInsets.zero,
              focusNode: FocusNode(),
              scrollable: false,
              scrollController: ScrollController(),
              autoFocus: true,
              showCursor: false,
              expands: false,
              enableInteractiveSelection: false,
            ),
          );
        } else {
          return Center(
            child: Text(Translator.of(context, "noContentCap")),
          );
        }
      },
    );
  }

  Future<void> _getDocument() async {
    if (_document != null) {
      return;
    }
    try {
      var docText = await FirebaseAPI.getAboutDoc();
      var doc = quill.Document.fromJson(jsonDecode(docText!));
      setState(() {
        _document = doc;
      });
    } catch (e) {
      debugPrint("AboutPage._getDocument: " + e.toString());
      return;
    }
  }
}
