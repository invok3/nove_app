import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:novel_controlpanel/controllers/firebase_api.dart';
import 'package:novel_controlpanel/pages/components/appbar.dart';
import 'package:novel_controlpanel/pages/components/func.dart';

class EditStoryTab extends StatefulWidget {
  static String routeName = "/StoriesTab/EditStoryTab";

  const EditStoryTab({Key? key}) : super(key: key);

  @override
  State<EditStoryTab> createState() => _EditStoryTabState();
}

class _EditStoryTabState extends State<EditStoryTab> {
  late quill.QuillController qController;

  late bool isProtrait;

  late DateTime _publishAt;
  bool _delayed = false;
  late bool _canDelay;
  late TextEditingController _pdController;
  late TextEditingController _title;
  late TextEditingController _description;
  String? _error;
  late Map<String, String?> args;

  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);

//////////////////////

    try {
      args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    } catch (e) {
      debugPrint(e.toString());
      args = {};
    }

    try {
      _publishAt =
          DateTime.fromMillisecondsSinceEpoch(int.parse(args["id"] ?? ""));

      _canDelay = false;

      _pdController = TextEditingController(
          text: "${_publishAt.year}/${_publishAt.month}/${_publishAt.day}");

      _title = TextEditingController(text: args["title"]);

      _description = TextEditingController(text: args["subtitle"]);

      qController = quill.QuillController(
          document: quill.Document.fromJson(jsonDecode(args["document"] ?? "")),
          selection: TextSelection(baseOffset: 0, extentOffset: 0));
    } catch (e) {
      debugPrint(e.toString());
      _publishAt = DateTime.now();
      _canDelay = true;
      _pdController = TextEditingController();
      _title = TextEditingController();
      _description = TextEditingController();
      qController = quill.QuillController(
          document: quill.Document(),
          selection: TextSelection(baseOffset: 0, extentOffset: 0));
    }

////////////////

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "تحرير حلقة",
      ),
      body: SafeArea(
        child: args["catID"] == null || args["catID"] == ""
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Error: Category ID was not provided!"),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Back"))
                  ],
                ),
              )
            : Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: quill.QuillToolbar.basic(
                        showVideoButton: false,
                        showDividers: true,
                        controller: qController,
                        showAlignmentButtons: true),
                  ),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(4)),
                          child: quill.QuillEditor(
                            embedBuilder:
                                (context, controller, node, readOnly, _) {
                              debugPrint(node.value.data.toString());
                              //return ScaleableImage(src: node.value.data);
                              return Image.network(
                                node.value.data,
                              );
                            },
                            controller: qController,
                            focusNode: FocusNode(),
                            scrollController: ScrollController(),
                            scrollable: true,
                            padding: EdgeInsets.zero,
                            autoFocus: true,
                            readOnly: false,
                            expands: true,
                            showCursor: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextField(
                                controller: _title,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "العنوان: ",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                    value: _delayed,
                                    onChanged: (delayed) {
                                      if (!_canDelay) {
                                        return;
                                      }
                                      setState(() {
                                        _delayed = delayed ?? false;
                                        _pdController.text = _delayed
                                            ? "${_publishAt.year}/${_publishAt.month}/${_publishAt.day}"
                                            : "";
                                      });
                                    }),
                                Text("جدولة"),
                                SizedBox(width: 4),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    controller: _pdController,
                                    readOnly: true,
                                    enabled: _delayed,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.calendar_today),
                                          onPressed: () async {
                                            await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now()
                                                        .subtract(Duration(
                                                            days: 356)),
                                                    lastDate: DateTime.now()
                                                        .add(Duration(
                                                            days: 3652)))
                                                .then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  _publishAt = value;
                                                  _pdController.text =
                                                      "${_publishAt.year}/${_publishAt.month}/${_publishAt.day}";
                                                });
                                              }
                                            });
                                          },
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextField(
                                controller: _description,
                                maxLines: 2,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "الوصف: ",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        _error != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red[700],
                                    ),
                                    Text(
                                      _error!,
                                      style: TextStyle(color: Colors.red[700]),
                                    )
                                  ])
                            : SizedBox(),
                        SizedBox(height: 8),
                        ElevatedButton(
                            onPressed: () {
                              editStory();
                            },
                            child: Text("نشر")),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  editStory() async {
    if (_title.text.isEmpty) {
      setState(() {
        _error = "العنوان مطلوب";
      });
      return;
    }

    String? result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: FutureBuilder(
                future: FirebaseAPI.editStory(
                    id: args["id"] ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    document:
                        jsonEncode(qController.document.toDelta().toJson()),
                    title: _title.text,
                    description: _description.text,
                    catID: args["catID"] ?? ""),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    Navigator.of(context).pop(snapshot.data);
                    return Container();
                  }
                },
              ),
            ));
    if (result != null) {
      setState(() {
        _error = "حدث خطأ أثناء الإتصال بقاعدة البيانات";
      });
    } else {
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
    }
  }
}
