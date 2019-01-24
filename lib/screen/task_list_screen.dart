import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stack_task/datasource/firebase_database_datasource.dart';
import 'package:stack_task/kind/task_item.dart';
import 'package:stack_task/screen/abstract_app_screen_state.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:stack_task/screen/abstract_stateful_screen.dart';

class TaskListScreen extends BaseStatefulScreen {
  TaskListScreen({Key key, FirebaseUser user}) : super(key: key, currentUser: user);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends AbstractAppScreenState<TaskListScreen> {
  final String title = 'Task List';

  List<TaskItem> _itemList = List();

  @override
  void initState() {
    super.initState();
    FirebaseDatabaseDatasource().getReference().child(widget.currentUser.uid).onChildAdded.listen(_onData);
  }

  void _onData(Event e) {
    setState(() {
      _itemList.add(TaskItem.fromSnapshot(e.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: createDrawer(context, widget.currentUser),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF19d02a), child: Icon(Icons.add_circle), onPressed: _addNewTask),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => _buildItemCard(index),
        itemCount: _itemList.length,
      ),
    );
  }

  Widget _buildItemCard(int index) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Checkbox(
            value: _itemList[index].finished,
            onChanged: (bool value) {
              // TODO 値変更時の処理を書く
              _itemList[index].finished = value;
            },
          ),
          Row(
            children: <Widget>[
              Text(
                _itemList[index].taskName,
                overflow: TextOverflow.ellipsis,
              ),
              Column(
                children: <Widget>[
                  Text(
                    _itemList[index].dueDate.toIso8601String(),
                  ),
                  SmoothStarRating(
                    allowHalfRating: false,
                    starCount: 3,
                    rating: _itemList[index].priority.toDouble(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addNewTask() {
    Navigator.of(context).pushNamed('/taskadd');
  }
}
