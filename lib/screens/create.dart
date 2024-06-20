import 'package:flutter/material.dart';

class CreateTaskPage extends StatefulWidget {
  CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;

  TimeOfDay? _selectedTime;

  String _priority = 'Medium';

  String _category = 'Work';

  bool _reminder = false;

  final List<String> _priorities = ['High', 'Medium', 'Low'];

  final List<String> _categories = ['Work', 'Personal', 'Others'];

  Future<void> _pickDate(BuildContext context, ValueSetter<DateTime?> onDatePicked) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    onDatePicked(pickedDate);
  }

  Future<void> _pickTime(BuildContext context, ValueSetter<TimeOfDay?> onTimePicked) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    onTimePicked(pickedTime);
  }

  void _saveTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task saved successfully')),
      );
      _formKey.currentState!.reset();
      _titleController.clear();
      _descriptionController.clear();
      // Reset other state variables if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Task Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
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
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _pickDate(context, (pickedDate) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            _selectedTime == null
                                ? 'No time chosen'
                                : _selectedTime!.format(context),
                          ),
                          trailing: const Icon(Icons.access_time),
                          onTap: () => _pickTime(context, (pickedTime) {
                            setState(() {
                              _selectedTime = pickedTime;
                            });
                          }),
                        ),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    value: _priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
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
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
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
                    title: const Text('Reminder'),
                    value: _reminder,
                    onChanged: (value) {
                      setState(() {
                        _reminder = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _saveTask(context),
                          child: const Text('Save'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                            setState(() {
                              _selectedDate = null;
                              _selectedTime = null;
                              _priority = 'Medium';
                              _category = 'Work';
                              _reminder = false;
                            });
                            _titleController.clear();
                            _descriptionController.clear();
                          },
                          child: const Text('Reset'),
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
          );
        },
      ),
    );
  }
}
