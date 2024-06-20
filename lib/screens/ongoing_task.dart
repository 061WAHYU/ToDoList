import 'package:flutter/material.dart';
import 'package:todolist/database/database_helper.dart';// Import Database Helper

class OngoingTaskPage extends StatelessWidget {
  const OngoingTaskPage({super.key});

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
                  onTap: () {
                    // Aksi ketika item di-tap (opsional)
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
