import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stack_task/datasource/firebase_auth_datasource.dart';

abstract class AbstractAppScreenState<T extends StatefulWidget> extends State<T> {
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
              // ToDo : タスクリスト画面への遷移を書く
//              Navigator.of(context).pushReplacementNamed('/tasklist');
              debugPrint('タスクリストを押した');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Setting'),
            onTap: () {
              // ToDo : アプリ設定画面への遷移を書く
              debugPrint('設定を押した');
              Navigator.pop(context);
            },
          ),
          ListTile(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // ToDo : ログアウト要求を書く
              debugPrint('ログアウトを押した');
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
