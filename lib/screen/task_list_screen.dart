import 'package:flutter/material.dart';
import 'package:stack_task/screen/abstract_app_screen.dart';

class TaskListScreen extends AbstractAppScreen {

  TaskListScreen({Key key, String title}) : super(key: key, title: title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: createDrawer(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF19d02a),
        child: Icon(Icons.add_circle),
        onPressed: _addNewTask
      ),
      
    );
  }

  void _addNewTask() {

  }
}