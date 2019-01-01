import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stack_task/datasource/firebase_auth_datasource.dart';

abstract class AbstractAppScreen extends StatelessWidget {

  final String title;

  AbstractAppScreen({Key key, this.title}) : super(key: key);

  Future<FirebaseUser> currentUser() async {
    return await FirebaseAuthDatasource().currentUser();
  }

  /**
   * NavigationDrawerを組み立てる。
   * 
   * @param context 
   */
  Widget createDrawer(BuildContext context) {
    FirebaseUser user = currentUser() as FirebaseUser;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey
            ),
            child: Row(
              children: <Widget>[
                Image.network(user.photoUrl),
                Text(user.displayName),
                Text(user.email)
              ],
            )
          ),
          ListTile(
            title: Text('Task List'),
            onTap: () {
              // ToDo : タスクリスト画面への遷移を書く
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Setting'),
            onTap: () {
              // ToDo : アプリ設定画面への遷移を書く
              Navigator.pop(context);
            },
          ),
          ListTile(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // ToDo : ログアウト要求を書く
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}