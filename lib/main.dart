import 'package:flutter/material.dart';
import 'package:todolist/screens/completed_tasks_screen.dart';
import 'package:todolist/screens/home_screen.dart';
import 'package:todolist/screens/login_screen.dart';
import 'package:todolist/screens/ongoing_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key, 
    required this.title, 
    required this.username, 
    required this.email, 
    required this.profilePicUrl,
  });
  final String title;
  final String username;
  final String email;
  final String profilePicUrl;
  
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
          UserAccountsDrawerHeader(
            accountName: Text(widget.username),
            accountEmail: Text(widget.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(widget.profilePicUrl),
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
                MaterialPageRoute(builder: (context) => OngoingTaskPage()),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
