import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Task {
  String? objectId;
  String title;
  DateTime dueDate;
  bool status;

  Task({
    this.objectId,
    required this.title,
    required this.dueDate,
    this.status = false,
  });

  // Convert a Task to a ParseObject for storing in the database
  ParseObject toParseObject() {
    final taskObject = ParseObject('Task')
      ..set('title', title)
      ..set('status', status)
      ..set('dueDate', dueDate);
    return taskObject;
  }

  // Convert a ParseObject to Task model
  static Task fromParseObject(ParseObject parseObject) {
    return Task(
      objectId: parseObject.objectId,
      title: parseObject.get('title'),
      dueDate: parseObject.get('dueDate'),
      status: parseObject.get('status'),
    );
  }
}
