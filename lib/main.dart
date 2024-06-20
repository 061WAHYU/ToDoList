import 'package:flutter/material.dart';
import 'package:gami/screens/completed_tasks_screen.dart';
import 'package:gami/screens/home_screen.dart';
import 'package:gami/screens/ongoing_task.dart';
import 'package:gami/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(title: 'ToDo List'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: _drawer(context),
      body: HomeScreen(),
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Nama Pengguna"),
            accountEmail: Text("email@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://example.com/avatar.jpg"),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(96, 205, 255, 1),
            ),
          ),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.task,
            text: 'Tugas Berlangsung',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OngoingTasksPage()),
              );
            },
          ),
          _createDrawerItem(
              icon: Icons.check_circle,
              text: 'Tugas Selesai',
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => CompletedTasksPage())
                );
                // Navigasi ke halaman Tugas Selesai
              },
            ),
            _createDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                Navigator.pop(context);
                // Implementasikan fitur logout
              },
            ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: RichText(
        text: const TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'ToDo',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'List',
              style: TextStyle(
                color: Color.fromRGBO(96, 205, 255, 1),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
    );
  }

  ListTile _createDrawerItem({required IconData icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
