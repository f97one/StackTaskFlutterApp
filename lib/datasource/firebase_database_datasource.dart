import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseDatasource {
  DatabaseReference _mainReference;

  final String _referenceTag = 'StackTask';

  FirebaseDatabaseDatasource() {
    _mainReference = FirebaseDatabase.instance.reference().child(_referenceTag);
  }

  Future<DataSnapshot> readTasksOnce(String uid) async {
    return await _mainReference.child(uid).once();
  }

  DatabaseReference getReference() => _mainReference;
}
