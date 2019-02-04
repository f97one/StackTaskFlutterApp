import 'package:stack_task/datasource/preference_datasource.dart';
import 'package:quiver/core.dart';

class DropdownItemValuePair {
  int key;
  String value;

  DropdownItemValuePair(this.key) {
    switch (this.key) {
      case PreferenceDatasource.ORDER_BY_DUE_DATE:
        this.value = 'Due Date';
        break;
      case PreferenceDatasource.ORDER_BY_PRIORITY:
        this.value = 'Priority';
        break;
      case PreferenceDatasource.ORDER_BY_TASK_NAME:
        this.value = 'Task Name';
        break;
      default:
        this.value = '';
    }
  }

  @override
  bool operator ==(other) {
    return other is DropdownItemValuePair && this.key == other.key && this.value == other.value;
  }

  @override
  int get hashCode {
    return hash2(this.key.hashCode, this.value.hashCode);
  }
}
