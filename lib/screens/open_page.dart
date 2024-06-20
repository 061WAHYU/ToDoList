// lib/screens/open_page.dart
import 'package:flutter/material.dart';
import 'package:gami/models/task.dart';
import 'package:gami/screens/create_page.dart';

class OpenPage extends StatefulWidget {
  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  List<Task> tasks = [

  ];

  String searchQuery = '';
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = tasks.where((task) {
      final matchesSearch = task.title.contains(searchQuery) || task.description.contains(searchQuery);
      final matchesFilter = showCompleted ? task.isCompleted : !task.isCompleted;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(tasks, (query) {
                  setState(() {
                    searchQuery = query;
                  });
                }),
              );
            },
          ),
          IconButton(
            icon: Icon(showCompleted ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: () {
              setState(() {
                showCompleted = !showCompleted;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePage(task: task),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      tasks.remove(task);
                    });
                  },
                ),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      task.isCompleted = value ?? false;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePage(),
            ),
          ).then((newTask) {
            if (newTask != null) {
              setState(() {
                tasks.add(newTask);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskSearchDelegate extends SearchDelegate<String> {
  final List<Task> tasks;
  final ValueChanged<String> onQueryUpdate;

  TaskSearchDelegate(this.tasks, this.onQueryUpdate);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onQueryUpdate(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = tasks.where((task) {
      return task.title.contains(query) || task.description.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final task = suggestions[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          onTap: () {
            close(context, task.title);
            onQueryUpdate(query);
          },
        );
      },
    );
  }
}
