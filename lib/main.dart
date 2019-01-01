import 'package:flutter/material.dart';
import 'package:stack_task/screen/login_screen.dart';
import 'package:stack_task/screen/splash_screen.dart';
import 'package:stack_task/screen/task_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder> {
        '/': (_) => LoginScreen(title: 'Login'),
        '/tasklist': (_) => TaskListScreen(title: 'Task List'),
      },
    );
  }
}
