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
      body: _handleScreen(context),
    );
  }

  Widget _handleScreen(BuildContext context) {
    FirebaseAuthDatasource datasource = FirebaseAuthDatasource();

    if (datasource.currentUser() != null) {
      Navigator.of(context).pushReplacementNamed('/tasklist');
    }

    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child:
                  RaisedButton(
                    key:null,
                    onPressed: _requestLoginWithGoogle,
                    color: const Color(0xFF0099ed),
                    child: Text(
                      "Login with Google",
                      style: TextStyle(
                        fontSize:12.0,
                        color: const Color(0xFFffffff),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Roboto"
                      )
                    )
                  ),
              )
            ],
          );
  }

  void _requestLoginWithGoogle() {
    FirebaseUser user = FirebaseAuthDatasource().handleSignIn();
    if (user != null) {
      
    }
  }
}