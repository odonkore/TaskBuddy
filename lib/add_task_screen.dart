import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_list_screen.dart'; // Make sure this import exists

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  DateTime? _selectedDateTime;

  final Color yellow = const Color(0xFFFFD700);
  final Color black = const Color(0xFF000000);
  final Color white = const Color(0xFFFFFFFF);

  /// ✅ Add new task to Firestore and go to TaskListScreen
  Future<void> _addTask() async {
    if (_titleController.text.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title and select a due date.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'dueDate': Timestamp.fromDate(_selectedDateTime!),
        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        // Navigate to TaskListScreen after task is added
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TaskListScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add task: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  /// ✅ Select date and time, format to "Mon, 7 April, 4:00 PM"
  Future<void> _selectDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && mounted) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null && mounted) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDateTime = finalDateTime;
          _dueDateController.text =
              DateFormat('EEE, d MMMM, h:mm a').format(finalDateTime);
        });
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
                    borderSide: BorderSide(color: black)),
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
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: black)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: yellow, width: 2)),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _selectDueDate,
              child: AbsorbPointer(
                child: TextField(
                  controller: _dueDateController,
                  style: TextStyle(color: black),
                  decoration: InputDecoration(
                    labelText: 'Due Date',
                    labelStyle: TextStyle(color: black),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: yellow, width: 2)),
                  ),
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
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Add Task',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
