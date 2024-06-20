import 'package:flutter/material.dart';
import 'package:todolist/database/database_helper.dart'; // Import Database Helper

class TaskDetailPage extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailPage({super.key, required this.task});

  Future<void> _deleteTask(BuildContext context, int id) async {
    await DatabaseHelper().deleteTask(id);
    Navigator.pop(context); // Kembali ke halaman sebelumnya setelah menghapus task
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task['title']),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _deleteTask(context, task['id']);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  task['description'],
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[600]),
                    const SizedBox(width: 8.0),
                    Text(
                      'Date: ${task['date']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey[600]),
                    const SizedBox(width: 8.0),
                    Text(
                      'Time: ${task['time']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.priority_high, color: Colors.grey[600]),
                    const SizedBox(width: 8.0),
                    Text(
                      'Priority: ${task['priority']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.category, color: Colors.grey[600]),
                    const SizedBox(width: 8.0),
                    Text(
                      'Category: ${task['category']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(Icons.alarm, color: Colors.grey[600]),
                    const SizedBox(width: 8.0),
                    Text(
                      'Reminder: ${task['reminder'] == 1 ? 'Yes' : 'No'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
