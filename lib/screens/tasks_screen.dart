import 'package:flutter/material.dart';
import 'package:quicktask/services/task_service.dart';
import 'package:quicktask/models/task.dart';
import 'package:quicktask/screens/add_task_screen.dart';
import 'package:quicktask/screens/edit_task_screen.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> _tasksList = []; // Hold the list of tasks locally

  @override
  void initState() {
    super.initState();
    _fetchTasks();  // Initial fetch of tasks
  }

  // Fetch tasks from the backend
  void _fetchTasks() async {
    List<Task> tasks = await TaskService().getTasks();  // Fetch tasks from the backend
    setState(() {
      _tasksList = tasks;  // Update the task list
    });
  }

  void _updateTasks() async {
    List<Task> tasks = await TaskService().getTasks();  // Fetch tasks from the backend
    setState(() {
      _tasksList = tasks;  // Update the task list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Tasks'),
      ),
      body: _tasksList.isEmpty
          ? Center(child: Text("You do not have any reminders")) // Show a message if no tasks are available
          : ListView.builder(
        itemCount: _tasksList.length,
        itemBuilder: (context, index) {
          final task = _tasksList[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text('Due: ${task.dueDate.toLocal().toString()}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit Icon
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskScreen(task: task),
                      ),
                    ).then((updatedTask) {
                      if (updatedTask != null) {
                        setState(() {
                          _tasksList[index] = updatedTask; // Update task in the list
                        });
                      }
                    });
                  },
                ),
                // Delete Icon
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteDialog(task, index);
                  },
                ),
              ],
            ),
            leading: ElevatedButton(
              onPressed: () {
                if (task.objectId != null) {
                  TaskService().toggleTaskStatus(task.objectId!, !task.status);
                  setState(() {
                    task.status = !task.status; // Toggle the status
                  });
                } else {
                  // Handle the null objectId case if needed
                  print("Task objectId is null");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: task.status ? Colors.green : Colors.red, // Green for completed, Red for pending
              ),
              child: Text(
                task.status ? 'Completed' : 'Pending',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddTaskScreen when FAB is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          ).then((newTask) {
            // If a new task is returned, update the task list
            if (newTask != null) {
              setState(() {
                _tasksList.add(newTask); // Add new task to the list
              });
            }
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Task',
      ),
    );
  }

  void _showDeleteDialog(Task task, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                if (task.objectId != null) {
                  TaskService().deleteTask(task.objectId!); // Ensure objectId is not null
                  setState(() {
                    _tasksList.removeAt(index); // Remove task from the list
                  });
                } else {
                  // Handle the null objectId case if needed
                  print("Task objectId is null");
                }
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
