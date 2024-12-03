import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:quicktask/models/task.dart';

class TaskService {
  // Add a new task
  Future<Task?> addTask(Task task) async {
    final taskObject = task.toParseObject();
    var response = await taskObject.save();

    if (response.success) {
      print('Task added successfully');
      // Return the task with the populated objectId
      return Task.fromParseObject(response.result);
    } else {
      print('Failed to add task');
      return null;  // Return null if task creation fails
    }
  }

  // Fetch all tasks from the database
  Future<List<Task>> getTasks() async {
    final query = QueryBuilder(ParseObject('Task'));
    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!.map((task) => Task.fromParseObject(task)).toList();
    } else {
      print('Error fetching tasks');
      return [];
    }
  }

  // Update task status
  Future<void> toggleTaskStatus(String taskId, bool currentStatus) async {
    final taskQuery = QueryBuilder(ParseObject('Task'))..whereEqualTo('objectId', taskId);
    final taskResponse = await taskQuery.query();

    if (taskResponse.success && taskResponse.results != null) {
      final task = taskResponse.results!.first as ParseObject;
      task.set('status', !currentStatus);
      var updateResponse = await task.save();
      if (updateResponse.success) {
        print('Task status updated');
      } else {
        print('Failed to update task');
      }
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    final taskQuery = QueryBuilder(ParseObject('Task'))..whereEqualTo('objectId', taskId);
    final taskResponse = await taskQuery.query();

    if (taskResponse.success && taskResponse.results != null) {
      final task = taskResponse.results!.first as ParseObject;
      var deleteResponse = await task.delete();
      if (deleteResponse.success) {
        print('Task deleted');
      } else {
        print('Failed to delete task');
      }
    }
  }

  // Update task details
  Future<void> updateTask(Task task) async {
    final taskQuery = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('objectId', task.objectId);
    final parseTask = await taskQuery.first();
    if (parseTask != null) {
      parseTask.set('title', task.title);
      parseTask.set('dueDate', task.dueDate);
      parseTask.set('status', task.status);
      await parseTask.save();
    }
  }
}
