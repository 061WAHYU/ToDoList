import 'package:flutter/material.dart';
import 'package:todolist/database/database_helper.dart'; // Import Database Helper
import 'task_detail_page.dart'; // Import Task Detail Page

class OngoingTaskPage extends StatefulWidget {
  const OngoingTaskPage({super.key});

  @override
  _OngoingTaskPageState createState() => _OngoingTaskPageState();
}

class _OngoingTaskPageState extends State<OngoingTaskPage> {
  Future<List<Map<String, dynamic>>> _fetchTasks() async {
    return await DatabaseHelper().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing Tasks'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading tasks'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ongoing tasks'));
          } else {
            List<Map<String, dynamic>> tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task['title']),
                  subtitle: Text(task['description']),
                  trailing: Text(task['priority']),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailPage(task: task),
                      ),
                    );
                    setState(() {}); // Refresh tasks list after returning
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
