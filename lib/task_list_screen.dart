import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/add_task_screen.dart';
import 'package:task_manager/edit_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Delete a task and show feedback if mounted
  Future<void> _deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete task: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              return ListTile(
                title: Text(task['title']),
                subtitle: Text(task['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit button
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskScreen(taskId: task.id),
                          ),
                        );
                      },
                    ),
                    // Delete button
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTask(task.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
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
