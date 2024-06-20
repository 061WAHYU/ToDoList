// completed_tasks_screen.dart
import 'package:flutter/material.dart';

class CompletedTasksPage extends StatelessWidget {
  const CompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tugas Selesai"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Belum ada tugas yang selesai.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
