import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novel_controlpanel/controllers/firebase_api.dart';
import 'package:novel_controlpanel/pages/components/appbar.dart';
import 'package:novel_controlpanel/pages/components/drawer_listview.dart';
import 'package:novel_controlpanel/pages/components/flex_sidebar.dart';
import 'package:novel_controlpanel/pages/components/func.dart';

class NotificationTab extends StatefulWidget {
  static String routeName = "/NotificationTab";

  const NotificationTab({Key? key}) : super(key: key);

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  late bool isProtrait;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _serverKeyController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);
    double x = (MediaQuery.of(context).size.width - 250) / 5;
    double y = MediaQuery.of(context).size.height / 7;
    x = x < y ? y : x;
    return Scaffold(
      drawer: isProtrait
          ? Drawer(
              child: MyDrawerListView(drawer: true),
              //backgroundColor: Colors.grey[800],
            )
          : null,
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "الأجزاء",
      ),
      body: SafeArea(
        child: FlexSideBar(
          isProtrait: isProtrait,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .7,
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2)),
                              labelText: "العنوان",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 24),
                          TextField(
                            controller: _imageController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.amber, width: 2)),
                                labelText: "رابط صورة",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                isDense: true,
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                                    color: Colors.amber,
                                    onPressed: () => selectPhoto(),
                                    icon: Icon(Icons.camera_alt))),
                          ),
                          SizedBox(height: 24),
                          TextField(
                            controller: _serverKeyController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2)),
                              labelText: "مفتاح",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 24),
                          TextField(
                            maxLength: 200,
                            maxLines: 5,
                            controller: _bodyController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2)),
                              labelText: "النص",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => sendNotification(),
                            child: Text(
                              "إرسال",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  selectPhoto() async {
    ImagePicker a = ImagePicker();
    XFile? xFile = await a.pickImage(source: ImageSource.gallery);
    if (xFile == null) {
      debugPrint("Aborted!");
      return;
    }
    debugPrint(xFile.name);
    Uint8List xBytes = await xFile.readAsBytes();
    String? xLink = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: FutureBuilder(
                future: FirebaseAPI.uploadPhoto(
                    fileName:
                        "${DateTime.now().millisecondsSinceEpoch}.${xFile.name.split('.').last}",
                    fileData: xBytes),
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
    if (xLink != null) {
      setState(() {
        _imageController.text = xLink;
      });
    }
  }

  sendNotification() async {
    if (_titleController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("خطأ"),
          content: Text("العنوان مطلوب!"),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context), child: Text("رجوع"))
          ],
          actionsAlignment: MainAxisAlignment.center,
        ),
      );
      return;
    }
    String result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: FutureBuilder(
          future: FirebaseAPI.sendMessage(
              title: _titleController.text,
              body: _bodyController.text.isEmpty ? null : _bodyController.text,
              imageUrl:
                  _imageController.text.isEmpty ? null : _imageController.text,
              serverKey: _serverKeyController.text.isEmpty
                  ? null
                  : _serverKeyController.text),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              );
            } else {
              Navigator.pop(context, snapshot.data);
              return SizedBox();
            }
          },
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result.contains("Error: ") ? "خطأ" : "تم"),
        content: Text(
            result.contains("Error: ") ? result : "تم إرسال الإشعار بنجاح."),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: Text("تم"))
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
    result.contains("Error: ")
        ? {
            for (TextEditingController c in [
              _titleController,
              _bodyController,
              _imageController,
              _serverKeyController
            ])
              {c.text = ""}
          }
        : null;
  }
}
