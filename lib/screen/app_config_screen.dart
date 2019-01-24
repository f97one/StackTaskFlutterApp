import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stack_task/screen/abstract_app_screen_state.dart';
import 'package:stack_task/screen/abstract_stateful_screen.dart';

class AppConfigScreen extends BaseStatefulScreen {
  AppConfigScreen({Key key, FirebaseUser user}) : super(key: key, currentUser: user);

  @override
  _AppConfigScreenState createState() => _AppConfigScreenState();
}

class _AppConfigScreenState extends AbstractAppScreenState<AppConfigScreen> with WidgetsBindingObserver {
  final String title = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createDefaultAppBar(title),
      drawer: createDrawer(context, widget.currentUser),
      body: _createBody(),
    );
  }

  Widget _createBody() {
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.inactive) {
        // TODO : Preferenceへの書き戻し処理を書く
      }
    });
  }
}
