import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novel_controlpanel/controllers/firebase_api.dart';
import 'package:novel_controlpanel/pages/components/appbar.dart';
import 'package:novel_controlpanel/pages/components/drawer_listview.dart';
import 'package:novel_controlpanel/pages/components/flex_sidebar.dart';
import 'package:novel_controlpanel/pages/components/func.dart';

class ProfileTab extends StatefulWidget {
  static String routeName = "/ProfileTab";

  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late bool isProtrait;

  TextEditingController pwdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);
    return Scaffold(
      drawer: isProtrait
          ? Drawer(
              child: MyDrawerListView(drawer: true),
              //backgroundColor: Colors.grey[800],
            )
          : null,
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "الملف الشخصي",
      ),
      body: SafeArea(
        child: FlexSideBar(
          isProtrait: isProtrait,
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                FirebaseAuth.instance.currentUser!.displayName ??
                    FirebaseAuth.instance.currentUser!.email!.split("@").first,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.orange),
              ),
              SizedBox(
                height: 16,
              ),
              CircleAvatar(
                radius: 64,
                foregroundImage:
                    FirebaseAuth.instance.currentUser!.photoURL == null
                        ? null
                        : NetworkImage(
                            FirebaseAuth.instance.currentUser!.photoURL!),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () => selectPhoto(),
                  icon: Icon(Icons.camera_alt),
                  label: Text("تغيير الصورة")),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 4),
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: pwdController,
                      decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          labelText: "كلمة المرور الجديدة:"),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.currentUser!
                                .updatePassword(pwdController.text);
                          } catch (e) {
                            var x = e as FirebaseAuthException;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(x.message ?? "Unknown Error!")));
                            return;
                          }
                          if (!mounted) {
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("تم تغيير كلمة المرور")));
                        },
                        child: Text("تغيير كلمة المرور"))
                  ],
                ),
              )
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
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(xLink);
      setState(() {});
    }
  }
}
