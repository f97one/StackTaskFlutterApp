import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stack_task/datasource/firebase_database_datasource.dart';
import 'package:stack_task/datasource/preference_datasource.dart';
import 'package:stack_task/kind/task_item.dart';
import 'package:stack_task/screen/abstract_app_screen_state.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:stack_task/screen/abstract_stateful_screen.dart';

class TaskEditScreen extends BaseStatefulScreen {
  /// 引数保管用、外から書き換えさせさせたくないので private.
  TaskItem _taskItem;
  bool _isCreationMode = false;

  TaskEditScreen({Key key, FirebaseUser user, TaskItem taskItem}) : super(key: key, currentUser: user) {
    _isCreationMode = taskItem == null;

    if (taskItem == null) {
      this._taskItem = TaskItem(null);
      this._taskItem.dueDate = DateTime.now().add(Duration(days: 7));
      this._taskItem.taskName = '';
      this._taskItem.priority = 1;
      this._taskItem.taskDetail = '';
      this._taskItem.finished = false;
    } else {
      this._taskItem = taskItem;
    }
  }

  /**
   * TaskItemのGetter.
   */
  TaskItem get taskItem => _taskItem;

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends AbstractAppScreenState<TaskEditScreen> {
  TextEditingController _taskNameController;
  TextEditingController _taskDetailController;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String title = widget._isCreationMode ? "Add Task" : "Edit Task";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: createDrawer(context, widget.currentUser),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF19d02a),
        child: Icon(Icons.edit),
        onPressed: _onSubmit,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    _taskNameController = TextEditingController(text: widget.taskItem.taskName);
    _taskDetailController = TextEditingController(text: widget.taskItem.taskDetail);

    return Form(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: 64.0,
                child: TextFormField(
                  maxLines: 1,
                  maxLength: 32,
                  controller: _taskNameController,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Due Date : '),
                  RaisedButton(
                    onPressed: _raiseDateTimePicker,
                    child: Text(widget.taskItem.dueDateByString()),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Priority : '),
                  SmoothStarRating(
                    starCount: 3,
                    rating: widget.taskItem.priority.toDouble(),
                    onRatingChanged: (v) {
                      setState(() {
                        widget.taskItem.priority = v.toInt();
                      });
                    },
                    allowHalfRating: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 180.0,
                child: TextFormField(
                  maxLines: 5,
                  maxLength: 200,
                  controller: _taskDetailController,
                  decoration: InputDecoration(
                    labelText: 'Task Detail',
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[_showFinishedCheck()],
            ),
          ],
        ),
      ),
    );
  }

  /// DatePicker → TimePicker の順に Dialog をあげる.
  Future<void> _raiseDateTimePicker() async {
    // firstDateは1か月前の初日にする
    int firstY;
    int firstM;
    if (widget.taskItem.dueDate.month == DateTime.january) {
      firstY = widget.taskItem.dueDate.year - 1;
      firstM = DateTime.december;
    } else {
      firstY = widget.taskItem.dueDate.year;
      firstM = widget.taskItem.dueDate.month - 1;
    }
    final DateTime firstDate = DateTime(firstY, firstM);

    // lastDateは12か月後の最終日にする
    final DateTime ld = DateTime(widget.taskItem.dueDate.year + 1, widget.taskItem.dueDate.month + 1);
    final DateTime lastDate = ld.add(Duration(days: -1));

    // DatePickerDialog起動
    final DateTime resultDt = await showDatePicker(
        context: context, initialDate: widget.taskItem.dueDate, firstDate: firstDate, lastDate: lastDate);

    // DatePickerDialogをユーザー操作でキャンセルした場合は、以後何もしない
    if (resultDt == null) {
      return;
    }

    // TimePickerDialog起動
    final TimeOfDay tod = TimeOfDay(hour: widget.taskItem.dueDate.hour, minute: widget.taskItem.dueDate.minute);
    final TimeOfDay resultToD = await showTimePicker(context: context, initialTime: tod);

    setState(() {
      if (resultDt != null && resultToD != null) {
        // Dart の DateTime には set がないので、新しいインスタンスを作って差し替える
        var newDt = DateTime(resultDt.year, resultDt.month, resultDt.day, resultToD.hour, resultToD.minute);
        widget.taskItem.dueDate = newDt;
      }
    });
  }

  Widget _showFinishedCheck() {
    if (widget._isCreationMode) {
      return Container();
    } else {
      return Row(
        children: <Widget>[
          Text('Done'),
          Checkbox(
            value: widget.taskItem.finished ?? false,
            onChanged: (v) {
              setState(() {
                widget.taskItem.finished = v;
              });
            },
          ),
        ],
      );
    }
  }

  void _onSubmit() {
    if (_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data...')));

      // TODO: 送信処理を書く

    }
  }
}
