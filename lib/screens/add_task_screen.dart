import 'package:flutter/material.dart';
import 'package:quicktask/models/task.dart';
import 'package:quicktask/services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime? _dueDate; // Store both date and time

  String? _title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Due Date & Time',
                  hintText: _dueDate == null
                      ? 'Select due date and time'
                      : _dueDate!.toLocal().toString(), // Show date and time
                ),
                onTap: () async {
                  // Show date picker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    // Show time picker after selecting the date
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        _dueDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        ); // Combine date and time
                      });
                    }
                  }
                },
                validator: (value) {
                  if (_dueDate == null) {
                    return 'Please select a due date and time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTask = Task(
        title: _title!,
        dueDate: _dueDate ?? DateTime.now(), // Use the selected date and time
        status: false,
      );

      TaskService().addTask(newTask).then((addTask) {
        Navigator.pop(context, addTask);
      });
    }
  }
}
