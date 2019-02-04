import 'package:shared_preferences/shared_preferences.dart';

class PreferenceDatasource {
  static const String _showConfirmationWhenCompleteChecked = 'showConfirmationWhenCompleteChecked';
  static const String _taskSortOrder = 'taskSortOrder';

  /// 期日で並べ替える
  static const int ORDER_BY_DUE_DATE = 1;

  /// 優先度で並べ替える
  static const int ORDER_BY_PRIORITY = 2;

  /// 名前で並び替える
  static const int ORDER_BY_TASK_NAME = 3;

  Future<bool> showConfirmationWhenCompleteChecked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 値がないときはtrueを返す
    return prefs.getBool(_showConfirmationWhenCompleteChecked) ?? true;
  }

  void setShowConfirmationWhenCompleteChecked(bool showConfirm) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showConfirmationWhenCompleteChecked, showConfirm);
  }

  Future<int> getTaskOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 値がないときは1(期日)を返す
    return prefs.getInt(_taskSortOrder) ?? ORDER_BY_DUE_DATE;
  }

  void setTaskOrder(int taskOrder) async {
    switch (taskOrder) {
      case ORDER_BY_DUE_DATE:
      case ORDER_BY_PRIORITY:
      case ORDER_BY_TASK_NAME:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_taskSortOrder, taskOrder);
        break;
      default:
        throw Exception("$taskOrder not allowed.");
        break;
    }
  }
}
