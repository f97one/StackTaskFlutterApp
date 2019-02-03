import 'package:firebase_database/firebase_database.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

/// タスクアイテム
class TaskItem {
  String taskName;

  /// タスクID
  String taskId;

  /// 期日
  DateTime dueDate;

  /// 優先度
  int priority;

  /// タスク詳細
  String taskDetail;

  /// 終了フラグ
  bool finished;

  /// 作成日
  DateTime createdAt;

  /// 更新日
  DateTime updatedAt;

  TaskItem(this.taskName);

  TaskItem.fromSnapshot(DataSnapshot dataSnapshot) {
    taskName = dataSnapshot.value['taskName'] as String;
    taskId = dataSnapshot.value['taskId'] as String;
    dueDate = DateTime.fromMillisecondsSinceEpoch(dataSnapshot.value["dueDate"] as int);
    priority = dataSnapshot.value['priority'] as int;
    taskDetail = dataSnapshot.value['taskDetail'] as String;
    finished = dataSnapshot.value['finished'] as bool;
    createdAt = DateTime.fromMillisecondsSinceEpoch(dataSnapshot.value["createdAt"] as int);
    updatedAt = DateTime.fromMillisecondsSinceEpoch(dataSnapshot.value["updatedAt"] as int);
  }

  Map<String, dynamic> toJson() => {
        'taskName': taskName,
        'taskId': taskId,
        'dueDate': dueDate.millisecondsSinceEpoch,
        'priority': priority,
        'taskDetail': taskDetail,
        'finished': finished,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch
      };

  /// 期日をDateTimeから書式設定済みStringとして取得する。
  String dueDateByString() {
    initializeDateFormatting("ja_JP");
    var formatter = DateFormat('yyyy/MM/dd HH:mm', "ja_JP");
    return formatter.format(this.dueDate);
  }
}
