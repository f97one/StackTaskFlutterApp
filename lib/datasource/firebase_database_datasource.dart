import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:stack_task/kind/task_item.dart';

class FirebaseDatabaseDatasource {
  DatabaseReference _mainReference;

  /// このアプリで使う DatabaseReference.
  DatabaseReference get reference => _mainReference;

  final String _referenceTag = 'StackTask';

  FirebaseDatabaseDatasource() {
    _mainReference = FirebaseDatabase.instance.reference().child(_referenceTag);
  }

  Future<DataSnapshot> readTasksOnce(String uid) async {
    return await _mainReference.child(uid).once();
  }

  /// タスクをRealtime Databaseに送る。
  ///
  /// * taskItem : 送るタスク情報
  /// * uid : ユーザーのUID
  /// * isCreation : 追加の時true、更新の時false、デフォルトfalse
  Future<void> putTask({TaskItem taskItem, String uid, bool isCreation = false}) async {
    var ref = reference.child(uid);

    taskItem.updatedAt = DateTime.now();

    if (isCreation) {
      taskItem.taskId = ref.push().key;
      taskItem.createdAt = DateTime.now();
    }
    Map<String, dynamic> updateMap = {taskItem.taskId: taskItem.toJson()};

    await ref.update(updateMap);
  }
}
