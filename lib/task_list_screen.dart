import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Tasks'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10, // Replace with your actual tasks data length
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text('Task #$index'),
                subtitle: Text('Task description here'),
                onTap: () {
                  // Navigate to task detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskDetailScreen(taskId: index)),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  final int taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task #$taskId Details'),
      ),
      body: Center(
        child: Text('Details for Task #$taskId'),
      ),
    );
  }
}
