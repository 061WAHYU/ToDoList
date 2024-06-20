import 'package:flutter/material.dart';
import 'package:gami/models/task_model.dart';

class OngoingTasksPage extends StatelessWidget {
  OngoingTasksPage({super.key});

  // Contoh data tugas yang sedang berlangsung
  final List<TaskModel> ongoingTasks = [
    TaskModel(title: 'Kerjakan Laporan', description: 'Selesaikan laporan proyek A', dueDate: DateTime.now().add(Duration(days: 2))),
    TaskModel(title: 'Desain UI', description: 'Buat desain UI untuk aplikasi mobile', dueDate: DateTime.now().add(Duration(days: 3))),
    TaskModel(title: 'Presentasi Klien', description: 'Persiapkan presentasi untuk klien baru', dueDate: DateTime.now().add(Duration(days: 4))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas Berlangsung'),
        backgroundColor: Color.fromRGBO(96, 205, 255, 1),
      ),
      body: ListView.builder(
        itemCount: ongoingTasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              leading: Icon(Icons.assignment, color: Colors.blue),
              title: Text(ongoingTasks[index].title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                ongoingTasks[index].description,
                style: TextStyle(color: Colors.black54),
              ),
              trailing: Text(
                _formatDate(ongoingTasks[index].dueDate),
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                _showTaskDetails(context, ongoingTasks[index]);
              },
            ),
          );
        },
      ),
    );
  }

  // Format tanggal menjadi string yang lebih ramah pengguna
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Tampilkan dialog detail tugas
  void _showTaskDetails(BuildContext context, TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Text('Deskripsi: ${task.description}\nBatas waktu: ${_formatDate(task.dueDate)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
