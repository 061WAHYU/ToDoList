import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todolist/database/database_helper.dart';
import 'package:todolist/models/category_model.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await DatabaseHelper().getCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _addCategory() async {
    final result = await showDialog<CategoryModel>(
      context: context,
      builder: (context) => _CategoryDialog(),
    );
    if (result != null) {
      await DatabaseHelper().insertCategory(result);
      _loadCategories();
    }
  }

  void _editCategory(CategoryModel category) async {
    final result = await showDialog<CategoryModel>(
      context: context,
      builder: (context) => _CategoryDialog(category: category),
    );
    if (result != null) {
      await DatabaseHelper().updateCategory(result);
      _loadCategories();
    }
  }

  void _deleteCategory(int id) async {
    await DatabaseHelper().deleteCategory(id);
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCategory,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ListTile(
            title: Text(category.name),
            leading: CircleAvatar(
              backgroundColor: category.boxColor,
              child: Icon(
                Icons.category,
                color: Colors.white,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editCategory(category),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteCategory(category.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryDialog extends StatefulWidget {
  final CategoryModel? category;

  _CategoryDialog({this.category});

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconPathController = TextEditingController();
  Color _boxColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _iconPathController.text = widget.category!.iconPath;
      _boxColor = widget.category!.boxColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _iconPathController,
              decoration: const InputDecoration(labelText: 'Icon Path'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an icon path';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Color:'),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    Color? pickedColor = await showDialog(
                      context: context,
                      builder: (context) => _ColorPickerDialog(initialColor: _boxColor),
                    );
                    if (pickedColor != null) {
                      setState(() {
                        _boxColor = pickedColor;
                      });
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: _boxColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(CategoryModel(
                id: widget.category?.id,
                name: _nameController.text,
                iconPath: _iconPathController.text,
                boxColor: _boxColor, 
                page: CategoryPage(),
              ));
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ColorPickerDialog extends StatelessWidget {
  final Color initialColor;

  _ColorPickerDialog({required this.initialColor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick Color'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: initialColor,
          onColorChanged: (color) => Navigator.of(context).pop(color),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
