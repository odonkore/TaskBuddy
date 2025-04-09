import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/add_task_screen.dart';
import 'package:task_manager/task_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getTasks() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('tasks').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'dueDate': data['dueDate']?.toDate(),
          'isCompleted': data['isCompleted'] ?? false,
        };
      }).toList();
    } catch (e) {
      developer.log('Error fetching tasks: $e');
      return [];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleCompletion(String taskId, bool newStatus) {
    _firestore.collection('tasks').doc(taskId).update({'isCompleted': newStatus});
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
      ? AppBar(
          title: const Text("Dashboard"),
        )
      : null, 
      body: _selectedIndex == 0
          ? FutureBuilder<List<Map<String, dynamic>>>(
              future: _getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Center(child: Text('Error fetching tasks.'));
                }

                final tasks = snapshot.data!;
                final today = DateTime.now();

                final filteredTasks = tasks.where((task) {
                  final due = task['dueDate'];
                  return due != null &&
                      due.year == today.year &&
                      due.month == today.month &&
                      due.day == today.day;
                }).toList();

                if (filteredTasks.isEmpty) {
                  return const Center(child: Text('No tasks with due dates today.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return TaskCard(
                      task: task,
                      onChanged: (bool? value) {
                        _toggleCompletion(task['id'], value ?? false);
                      },
                    );
                  },
                );
              },
            )
          : _selectedIndex == 1
              ? const AddTaskScreen()
              : const TaskListScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[700],
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

///task card
class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final ValueChanged<bool?> onChanged;

  const TaskCard({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = task['isCompleted'];
    final dueDate = task['dueDate'] as DateTime;

    return Card(
      color: isCompleted ? const Color(0xFFE8F5E9) : Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Checkbox(
              value: isCompleted,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted ? Colors.grey : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due: ${dueDate.toLocal().toString().substring(0, 16)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
