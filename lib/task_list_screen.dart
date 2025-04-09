import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/add_task_screen.dart';
import 'package:task_manager/edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Color yellow = const Color(0xFFFFD700);
  final Color black = const Color(0xFF000000);
  final Color white = const Color(0xFFFFFFFF);

  //Delete a task and show feedback if mounted
  Future<void> _deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted successfully!'),
            backgroundColor: yellow,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete task: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: yellow,
        foregroundColor: black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('tasks')
            .orderBy('dueDate')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: black)));
          }

          var tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              return Card(
                color: white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    task['title'],
                    style: TextStyle(color: black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    task['description'],
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(taskId: task.id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red[700]),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
 // floating action bar
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellow,
        foregroundColor: black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
