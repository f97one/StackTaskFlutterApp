import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stack_task/datasource/firebase_database_datasource.dart';
import 'package:stack_task/datasource/preference_datasource.dart';
import 'package:stack_task/kind/task_item.dart';
import 'package:stack_task/screen/abstract_app_screen_state.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:stack_task/screen/abstract_stateful_screen.dart';
import 'package:stack_task/screen/task_edit_screen.dart';

class TaskListScreen extends BaseStatefulScreen {
  TaskListScreen({Key key, FirebaseUser user}) : super(key: key, currentUser: user);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends AbstractAppScreenState<TaskListScreen> {
  final String title = 'Task List';

  List<TaskItem> _itemList = List();

  Map<TaskItem, bool> _itemCheckedConditions = Map();

  @override
  void initState() {
    super.initState();
    FirebaseDatabaseDatasource().getReference().child(widget.currentUser.uid).onChildAdded.listen(_onData);
  }

  void _onData(Event e) {
    setState(() {
      var item = TaskItem.fromSnapshot(e.snapshot);

      _itemList.add(item);
      _itemCheckedConditions[item] = item.finished;
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
        backgroundColor: const Color(0xFF19d02a),
        child: Icon(Icons.add_circle),
        onPressed: _addNewTask,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => _buildItemCard(index),
        itemCount: _itemList.length,
      ),
    );
  }

  Widget _buildItemCard(int index) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Checkbox(
              value: _itemList[index].finished,
              onChanged: (v) {
                setState(() {
                  debugPrint("onChange(v) が発火, value = $v");
                  _itemList[index].finished = v;
                  _itemCheckedConditions[_itemList[index]] = v;
                });
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _itemList[index].taskName,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _itemList[index].dueDateByString(),
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
    Navigator.of(context).push(MaterialPageRoute(
      settings: const RouteSettings(name: '/taskedit'),
      builder: (BuildContext ctx) => TaskEditScreen(
            user: widget.currentUser,
            taskItem: null,
          ),
    ));
  }
}
