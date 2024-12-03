import 'package:flutter/material.dart';
import 'package:quicktask/services/task_service.dart';
import 'package:quicktask/models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late DateTime _dueDate;
  late bool _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _dueDate = widget.task.dueDate;
    _status = widget.task.status;
  }

  Future<void> _updateTask() async {
    Task updatedTask = Task(
      objectId: widget.task.objectId,
      title: _titleController.text,
      dueDate: _dueDate,
      status: _status,
    );
    await TaskService().updateTask(updatedTask);
    Navigator.pop(context, updatedTask); // Return the updated task to the TasksScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            SizedBox(height: 16),
            Text('Due Date: ${_dueDate.toLocal()}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (newDate != null) {
                  setState(() {
                    _dueDate = newDate;
                  });
                }
              },
              child: Text('Pick Due Date'),
            ),
            SizedBox(height: 16),
            // This switch will update the task immediately when toggled
            SwitchListTile(
              title: Text('Completed'),
              value: _status,
              onChanged: (bool value) {
                setState(() {
                  _status = value;
                });
                // Call _updateTask immediately after the status is changed
                _updateTask();
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
