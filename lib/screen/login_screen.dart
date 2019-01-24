import 'package:flutter/material.dart';
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: '/tasklist'),
                          builder: (BuildContext context) => TaskListScreen(user: user),
                        ));
                  }
                }).catchError((onError) {
                  Fluttertoast.showToast(
                      msg: 'Authentication Failed, Please retry.',
                      gravity: ToastGravity.BOTTOM,
                      toastLength: Toast.LENGTH_SHORT);
                });
              },
              color: const Color(0xFF505050),
              child: Text("Login with Google",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFFcfcfcf),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"))),
        )
      ],
    );
  }
}
