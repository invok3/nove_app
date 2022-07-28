import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novel_controlpanel/controllers/firebase_api.dart';
import 'package:novel_controlpanel/pages/components/appbar.dart';

class EditCategoryTab extends StatefulWidget {
  static String routeName = "/EditCategoryTab";

  const EditCategoryTab({Key? key}) : super(key: key);

  @override
  State<EditCategoryTab> createState() => _EditCategoryTabState();
}

class _EditCategoryTabState extends State<EditCategoryTab> {
  String _imageLink = "";
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  String? _error;
  late String catID;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    String? cCatID = ModalRoute.of(context)?.settings.arguments as String?;
    catID = cCatID ?? DateTime.now().millisecondsSinceEpoch.toString();
    return Scaffold(
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "تحرير جزء",
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getCategory(cCatID),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 16,
                            vertical: 8),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 400, maxHeight: 260),
                          child: Card(
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(8)),
                            clipBehavior: Clip.hardEdge,
                            elevation: 10,
                            color: Colors.white,
                            child: Image(
                                image: NetworkImage(_imageLink),
                                width: 500,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, ice) {
                                  return ice == null
                                      ? child
                                      : SizedBox(
                                          width: 500,
                                          height: 300,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/500x300.png",
                                    width: 500,
                                    fit: BoxFit.cover,
                                  );
                                }),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => selectPhoto(),
                        child: Text("إختر صورة")),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 16,
                            vertical: 8),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextField(
                            controller: _title,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "العنوان: ",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 16,
                            vertical: 8),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextField(
                            controller: _description,
                            maxLines: 5,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "الوصف: ",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                        ),
                      ),
                    ),
                    _error == null
                        ? Container()
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[700]),
                              Text(_error ?? "Unknown Error!",
                                  style: TextStyle(color: Colors.red[700]))
                            ],
                          ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _error = null;
                          });
                          editCat();
                        },
                        child: Text("حفظ")),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  editCat() async {
    //id: widget.catID, image: _imageLink, title: _title.text, desription: _description.text
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
                future: FirebaseAPI.editCat(
                    id: catID,
                    image: _imageLink,
                    title: _title.text,
                    description: _description.text),
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
        _imageLink = xLink;
      });
    }
  }

  Future<void> getCategory(String? pCatID) async {
    //debugPrint(pCatID);
    if (pCatID == null || loaded == true) {
      return;
    } else {
      var x = await FirebaseAPI.getCat(id: pCatID);
      if (loaded == false) {
        setState(() {
          loaded = true;
          _title.text = x?["title"] ?? "";
          _description.text = x?["description"] ?? "";
          _imageLink = x?["image"] ?? "";
        });
      }
    }
  }
}
