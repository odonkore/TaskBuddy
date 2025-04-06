import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  // Constructor with named key parameter
  AddTaskScreen({Key? key}) : super(key: key);

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  // Add task to Firestore
  Future<void> _addTask() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'dueDate': _dueDateController.text,
      });

      // Ensure the widget is still mounted before navigating or showing a Snackbar
      if (mounted) {
        Navigator.pop(context); // Navigate back to task dashboard
      }
    } catch (e) {
      // Ensure the widget is still mounted before showing the Snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add task: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(labelText: 'Due Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
