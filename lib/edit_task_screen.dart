import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  // Constructor with named key parameter
  EditTaskScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  EditTaskScreenState createState() => EditTaskScreenState();
}

class EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  // Load task data from Firestore
  Future<void> _loadTaskData() async {
    DocumentSnapshot taskSnapshot = await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).get();

    if (taskSnapshot.exists) {
      Map<String, dynamic> taskData = taskSnapshot.data() as Map<String, dynamic>;
      _titleController.text = taskData['title'];
      _descriptionController.text = taskData['description'];
      _dueDateController.text = taskData['dueDate'];
    }
  }

  // Save updated task data to Firestore
  Future<void> _updateTask() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'dueDate': _dueDateController.text,
      });

      if (mounted) {
        Navigator.pop(context); // Navigate back to task dashboard
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update task: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
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
              onPressed: _updateTask,
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
