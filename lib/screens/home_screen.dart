import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/database/database_helper.dart';
import 'package:todolist/models/category_model.dart';
import 'package:todolist/screens/task_detail_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];
  late Stream<List<Map<String, dynamic>>> _tasksStream;
  Map<DateTime, List<dynamic>> _events = {};

  DateTime today = DateTime.now();

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  Stream<List<Map<String, dynamic>>> _fetchTasksStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      List<Map<String, dynamic>> tasks = await DatabaseHelper().getTasks();
      _generateEvents(tasks);
      yield tasks;
    }
  }

  void _generateEvents(List<Map<String, dynamic>> tasks) {
    _events.clear();
    for (var task in tasks) {
      DateTime taskDate = DateTime.parse(task['date']); // Asumsikan tugas memiliki field 'date' dalam format yyyy-MM-dd
      if (_events[taskDate] == null) {
        _events[taskDate] = [];
      }
      _events[taskDate]?.add(task);
    }
  }

  @override
  void initState() {
    super.initState();
    _tasksStream = _fetchTasksStream();
  }

  @override
  Widget build(BuildContext context) {
    _getCategories();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(),
          SizedBox(height: 40),
          _categoriesSection(context),
          _dateSection(),
          _ongoingTasksSection(),
        ],
      ),
    );
  }

  Container _searchField() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(15),
            hintText: 'Search Schedule, task, etc..',
            hintStyle: TextStyle(color: Color(0xffDDDADA), fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset('assets/icon/search.svg'),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }

  Column _categoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'CATEGORY',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 120,
          child: ListView.separated(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => SizedBox(width: 25),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => categories[index].page),
                  );
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: categories[index].boxColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(categories[index].iconPath),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          categories[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Column _dateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Text(
            'DATE SCHEDULE',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(181, 231, 255, 1),
            ),
            child: TableCalendar(
              focusedDay: today,
              firstDay: DateTime(2010, 10, 16),
              lastDay: DateTime(2030, 10, 16),
              eventLoader: (day) {
                return _events[day] ?? [];
              },
            ),
          ),
        )
      ],
    );
  }
  Widget _ongoingTasksSection() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _tasksStream,
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
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(task['description']),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.priority_high, size: 16, color: Colors.red),
                          SizedBox(width: 5),
                          Text(
                            task['priority'],
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailPage(task: task),
                      ),
                    );
                    setState(() {
                      _tasksStream = _fetchTasksStream(); // Refresh daftar tugas setelah kembali
                    });
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}

