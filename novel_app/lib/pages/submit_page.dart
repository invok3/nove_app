import 'package:flutter/material.dart';
import 'package:novel_app/controllers/firebase_api.dart';
import 'package:novel_app/providers/theme_provider.dart';
import 'package:novel_app/translate/translator.dart';
import 'package:provider/provider.dart';

class SubmitPage extends StatefulWidget {
  static String routeName = "/SubmitPage";

  const SubmitPage({Key? key}) : super(key: key);

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  InputDecoration mDecoration = const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0));

  TextEditingController contentController = TextEditingController();

  TextEditingController subjectController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  const Spacer(),
                  Text(
                    Translator.of(context, "contactUsTitle"),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color:
                            Provider.of<ThemeProvider>(context).selectedColor),
                  ),
                  const Spacer(),
                  const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.transparent,
                      )),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 28),
                    TextField(
                        controller: nameController,
                        decoration: mDecoration.copyWith(
                            labelText: Translator.of(context, "nameLabel"))),
                    const SizedBox(height: 28),
                    TextField(
                        controller: emailController,
                        decoration: mDecoration.copyWith(
                            labelText: Translator.of(context, "emailLabel"))),
                    const SizedBox(height: 28),
                    TextField(
                        controller: subjectController,
                        decoration: mDecoration.copyWith(
                            labelText: Translator.of(context, "subjectLabel"))),
                    const SizedBox(height: 28),
                    TextField(
                      controller: contentController,
                      decoration: mDecoration,
                      maxLength: 500,
                      maxLines: 10,
                    ),
                    const SizedBox(height: 7),
                    ElevatedButton(
                        onPressed: () => _submit(),
                        child: Text(Translator.of(context, "sendBtn"))),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submit() async {
    List<TextEditingController> c = [
      nameController,
      emailController,
      subjectController,
      contentController
    ];
    bool cango = true;
    for (TextEditingController cc in c) {
      if (cc.text.isEmpty) {
        cango = false;
      }
    }
    if (!cango) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(Translator.of(context, "ok")))
                ],
                content: Text(Translator.of(context, "errorAllFieldsRequired")),
              ));
    } else {
      String error = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: FutureBuilder(
                  future: FirebaseAPI.submit(
                      name: nameController.text,
                      email: emailController.text,
                      subject: subjectController.text,
                      content: contentController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      );
                    } else {
                      Navigator.of(context).pop(snapshot.data.toString());
                      return Container();
                    }
                  },
                ),
              ));
      if (error.contains("Error: ")) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(Translator.of(context, "errorTitle")),
            content: Text(Translator.of(context, "errorSubmitText")),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(Translator.of(context, "ok")))
            ],
          ),
        );
      } else {
        //submitted
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(Translator.of(context, "doneSubmitTitle")),
            content: Text(Translator.of(context, "doneSubmitText")),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(Translator.of(context, "ok")))
            ],
          ),
        );
      }
      for (TextEditingController cc in c) {
        cc.clear();
      }
    }
  }
}
