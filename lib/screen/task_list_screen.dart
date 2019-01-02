import 'package:flutter/material.dart';
import 'package:stack_task/screen/abstract_app_screen_state.dart';

class TaskListScreen extends StatefulWidget {

  TaskListScreen({Key key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();

}

class _TaskListScreenState extends AbstractAppScreenState<TaskListScreen> {

  final String title = 'Task List';

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
    Navigator.of(context).pushNamed('/taskadd');
  }

}