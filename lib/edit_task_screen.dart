import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  EditTaskScreenState createState() => EditTaskScreenState();
}

class EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  final Color yellow = const Color(0xFFFFD700);
  final Color black = const Color(0xFF000000);
  final Color white = const Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  /// ✅ Load existing task details from Firestore and populate fields
  Future<void> _loadTaskData() async {
    DocumentSnapshot taskSnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();

    if (taskSnapshot.exists) {
      Map<String, dynamic> taskData =
          taskSnapshot.data() as Map<String, dynamic>;
      _titleController.text = taskData['title'];
      _descriptionController.text = taskData['description'];
      _dueDateController.text = taskData['dueDate'];
    }
  }

  /// ✅ Update task in Firestore with new values
  Future<void> _updateTask() async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
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
            content: Text('Failed to update task: $e'),
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
        title: const Text('Edit Task'),
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
                enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: yellow, width: 2)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: black),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: black),
                enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: yellow, width: 2)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dueDateController,
              style: TextStyle(color: black),
              decoration: InputDecoration(
                labelText: 'Due Date',
                labelStyle: TextStyle(color: black),
                enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: yellow, width: 2)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                foregroundColor: black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Update Task',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
