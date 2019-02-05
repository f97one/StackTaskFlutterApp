import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stack_task/datasource/firebase_database_datasource.dart';
import 'package:stack_task/datasource/preference_datasource.dart';
import 'package:stack_task/kind/dropdown_item_valuepair.dart';
import 'package:stack_task/kind/task_item.dart';
import 'package:stack_task/screen/abstract_app_screen_state.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:stack_task/screen/abstract_stateful_screen.dart';
import 'package:stack_task/screen/dialog_action_types.dart';
import 'package:stack_task/screen/msg_dialog.dart';
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
    FirebaseDatabaseDatasource().reference.child(widget.currentUser.uid).onChildAdded.listen(_onData);
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
    List<DropdownItemValuePair> dropdownItems = [
      DropdownItemValuePair(PreferenceDatasource.ORDER_BY_DUE_DATE),
      DropdownItemValuePair(PreferenceDatasource.ORDER_BY_PRIORITY),
      DropdownItemValuePair(PreferenceDatasource.ORDER_BY_TASK_NAME)
    ];

    _sortTasks(taskOrderBy);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          PopupMenuButton<DropdownItemValuePair>(
            itemBuilder: (BuildContext context) {
              return dropdownItems.map((DropdownItemValuePair valuePair) {
                return PopupMenuItem<DropdownItemValuePair>(
                  value: valuePair,
                  child: Text(valuePair.value),
                );
              }).toList();
            },
            onSelected: (DropdownItemValuePair selected) {
              taskOrderBy = selected.key;
              _sortTasks(selected.key);
            },
          ),
        ],
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

  void _sortTasks(int taskOrder) {
    setState(() {
      switch (taskOrder) {
        case PreferenceDatasource.ORDER_BY_DUE_DATE:
          _itemList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          break;
        case PreferenceDatasource.ORDER_BY_PRIORITY:
          _itemList.sort((a, b) => b.priority.compareTo(a.priority));
          break;
        case PreferenceDatasource.ORDER_BY_TASK_NAME:
          _itemList.sort((a, b) => a.taskName.compareTo(b.taskName));
          break;
      }
    });
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

                if (showConfirm) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          MsgDialog(title: 'Confirm', content: 'This task is completed. Is it OK?', context: context)
                              .buildDialog()).then((value) {
                    switch (value) {
                      case DialogActionTypes.ok:
                        FirebaseDatabaseDatasource()
                            .putTask(taskItem: _itemList[index], uid: widget.currentUser.uid, isCreation: false);
                        break;
                      case DialogActionTypes.cancel:
                      default:
                        break;
                    }
                  });
                } else {
                  FirebaseDatabaseDatasource().putTask(taskItem: _itemList[index], uid: widget.currentUser.uid);
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                settings: const RouteSettings(name: '/taskedit'),
                builder: (BuildContext ctx) => TaskEditScreen(
                      user: widget.currentUser,
                      taskItem: _itemList[index],
                    ),
              ));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 6.0),
                  child: Text(
                    _itemList[index].taskName,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
