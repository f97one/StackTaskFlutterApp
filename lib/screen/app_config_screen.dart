import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stack_task/datasource/preference_datasource.dart';
import 'package:stack_task/kind/dropdown_item_valuepair.dart';
import 'package:stack_task/screen/abstract_app_screen_state.dart';
import 'package:stack_task/screen/abstract_stateful_screen.dart';

class AppConfigScreen extends BaseStatefulScreen {
  AppConfigScreen({Key key, FirebaseUser user}) : super(key: key, currentUser: user);

  @override
  _AppConfigScreenState createState() => _AppConfigScreenState();
}

class _AppConfigScreenState extends AbstractAppScreenState<AppConfigScreen> {
  final String title = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createDefaultAppBar(title),
      drawer: createDrawer(context, widget.currentUser),
      body: _createBody(),
    );
  }

  Widget _createBody() {
    List<DropdownItemValuePair> dropdownItems = [
      DropdownItemValuePair(PreferenceDatasource.ORDER_BY_DUE_DATE),
      DropdownItemValuePair(PreferenceDatasource.ORDER_BY_PRIORITY),
      DropdownItemValuePair(PreferenceDatasource.ORDER_BY_TASK_NAME)
    ];

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Task ordered by '),
              DropdownButton<DropdownItemValuePair>(
                items: dropdownItems.map((DropdownItemValuePair val) {
                  return DropdownMenuItem<DropdownItemValuePair>(
                    value: val,
                    child: Text(val.value),
                  );
                }).toList(),
                onChanged: (DropdownItemValuePair newVal) {
                  setState(() {
                    taskOrderBy = newVal.key;
                    PreferenceDatasource().setTaskOrder(newVal.key);
                  });
                },
                value: DropdownItemValuePair(taskOrderBy),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Show confirmation when task finishing'),
              Switch(
                value: showConfirm,
                onChanged: (v) {
                  setState(() {
                    debugPrint("passed $v");
                    showConfirm = v;
                    PreferenceDatasource().setShowConfirmationWhenCompleteChecked(v);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
