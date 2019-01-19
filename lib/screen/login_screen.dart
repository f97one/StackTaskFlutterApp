import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:stack_task/datasource/firebase_auth_datasource.dart';
import 'package:stack_task/screen/task_list_screen.dart';

class LoginScreen extends StatefulWidget {
  final String title;

  LoginScreen({Key key, this.title}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildLoginScreen(context),
    );
  }

  Widget _buildLoginScreen(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: RaisedButton(
              key: null,
              onPressed: () {
                FirebaseAuthDatasource().handleSignIn().then((user) {
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, '/tasklist');
                  }
                }).catchError((onError) {
                  Fluttertoast.showToast(
                      msg: 'Authentication Failed, Please retry.',
                      gravity: ToastGravity.BOTTOM,
                      toastLength: Toast.LENGTH_SHORT);
                });
              },
              color: const Color(0xFF0099ed),
              child: Text("Login with Google",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFFffffff),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"))),
        )
      ],
    );
  }
}
