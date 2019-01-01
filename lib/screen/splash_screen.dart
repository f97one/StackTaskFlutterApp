
import 'package:flutter/material.dart';
import 'package:stack_task/datasource/firebase_auth_datasource.dart';

/*
 * 初期化中表示するスプラッシュスクリーン。
 */
class SplashScreen extends StatefulWidget {

  final String title;

  SplashScreen({Key key, this.title}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/*
 * 初期化中表示の画面構成状態 
 */
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _handleScreen(context),
    );
  }

  Widget _handleScreen(BuildContext context) {
    FirebaseAuthDatasource datadource = FirebaseAuthDatasource();

    if (datadource.currentUser() != null) {
      Navigator.of(context).pushReplacementNamed('/tasklist');
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Initializing...',
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
          ),
        ],
      ),
    );
  }
}