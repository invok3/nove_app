import 'package:flutter/material.dart';
import 'package:novel_controlpanel/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:novel_controlpanel/pages/login_page.dart';
import 'package:novel_controlpanel/pages/control_panel_page.dart';

class StateManager extends StatefulWidget {
  const StateManager({Key? key}) : super(key: key);

  @override
  State<StateManager> createState() => _StateManagerState();
}

class _StateManagerState extends State<StateManager> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<UserProvider>(context).loadingUser == true
        ? Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : Provider.of<UserProvider>(context).currentUser == null
            ? LoginPage()
            : ControlPanelPage();
  }
}
