import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateTaskPage(),
    );
  }
}

class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _priority = 'Medium';
  String _category = 'Work';
  bool _reminder = false;

  List<String> _priorities = ['High', 'Medium', 'Low'];
  List<String> _categories = ['Work', 'Personal', 'Others'];

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      // Simpan tugas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task saved successfully')),
      );
      _formKey.currentState!.reset();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
                onSaved: (value) {
                  // Simpan judul tugas
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  // Simpan deskripsi tugas
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _selectedDate == null
                            ? 'No date chosen'
                            : '${_selectedDate!.toLocal()}'.split(' ')[0],
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: _pickDate,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _selectedTime == null
                            ? 'No time chosen'
                            : _selectedTime!.format(context),
                      ),
                      trailing: Icon(Icons.access_time),
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: _priorities.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              DropdownButtonFormField(
                value: _category,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Reminder'),
                value: _reminder,
                onChanged: (value) {
                  setState(() {
                    _reminder = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      child: Text('Save'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                        setState(() {
                          _selectedDate = null;
                          _selectedTime = null;
                        });
                      },
                      child: Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}