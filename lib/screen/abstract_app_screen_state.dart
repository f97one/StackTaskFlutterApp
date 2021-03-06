import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stack_task/datasource/firebase_auth_datasource.dart';
import 'package:stack_task/datasource/preference_datasource.dart';
import 'package:stack_task/screen/app_config_screen.dart';
import 'package:stack_task/screen/task_list_screen.dart';

abstract class AbstractAppScreenState<T extends StatefulWidget> extends State<T> {
  bool showConfirm = true;
  int taskOrderBy = PreferenceDatasource.ORDER_BY_DUE_DATE;

  PreferredSizeWidget createDefaultAppBar(String title) {
    return AppBar(
      title: Text(title),
    );
  }

  Widget createDrawer(BuildContext context, FirebaseUser firebaseUser) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.grey),
            child: Row(
              children: <Widget>[
                Image.network(firebaseUser.photoUrl),
                Padding(
                  padding: EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(firebaseUser.displayName),
                      Text(firebaseUser.email),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Task List'),
            onTap: () {
              Navigator.pop(context);
              // タスクリスト画面へ遷移
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: '/tasklist'),
                    builder: (BuildContext context) => TaskListScreen(user: firebaseUser),
                  ));
            },
          ),
          ListTile(
            title: Text('Setting'),
            onTap: () {
              // アプリ設定画面へ遷移
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/config'),
                  builder: (BuildContext context) => AppConfigScreen(user: firebaseUser),
                ),
              );
            },
          ),
          ListTile(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // ログアウト要求を出してログイン画面へ
              Navigator.pop(context);

              FirebaseAuthDatasource()
                  .logout()
                  .then((_) => Navigator.pushReplacementNamed(context, '/'))
                  .catchError((onError) {
                Fluttertoast.showToast(
                  msg: 'Logout Request Failed, Please retry.',
                  gravity: ToastGravity.BOTTOM,
                  toastLength: Toast.LENGTH_SHORT,
                );
              });
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var prefDs = PreferenceDatasource();

    prefDs.getTaskOrder().then((v) {
      setState(() {
        taskOrderBy = v;
      });
    });
    prefDs.showConfirmationWhenCompleteChecked().then((v) {
      setState(() {
        showConfirm = v;
      });
    });
  }
}
