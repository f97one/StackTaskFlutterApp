import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseStatefulScreen extends StatefulWidget {
  final FirebaseUser currentUser;

  BaseStatefulScreen({Key key, this.currentUser}) : super(key: key);
}
