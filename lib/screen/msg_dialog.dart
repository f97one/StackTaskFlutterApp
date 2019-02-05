import 'package:flutter/material.dart';
import 'package:stack_task/screen/dialog_action_types.dart';

class MsgDialog {
  final String title;
  final String content;
  final BuildContext context;

  MsgDialog({@required this.title, @required this.content, @required this.context});

  Widget buildDialog() {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context, DialogActionTypes.cancel),
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context, DialogActionTypes.ok),
          child: Text('OK'),
        ),
      ],
    );
  }
}
