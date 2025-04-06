import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  final Color yellow = const Color(0xFFFFD700);
  final Color black = const Color(0xFF000000);
  final Color white = const Color(0xFFFFFFFF);

  /// ✅ Add a task to Firestore with title, description, and due date
  Future<void> _addTask() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'dueDate': _dueDateController.text,
      });

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add task: $e'),
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
        title: const Text('Add Task'),
        backgroundColor: yellow,
        foregroundColor: black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: black),
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: yellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: black),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: yellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dueDateController,
              style: TextStyle(color: black),
              decoration: InputDecoration(
                labelText: 'Due Date',
                labelStyle: TextStyle(color: black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: yellow, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                foregroundColor: black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
