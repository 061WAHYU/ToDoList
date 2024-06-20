import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategoryManagementPage(),
    );
  }
}

class Category {
  String name;
  int taskCount;

  Category({required this.name, required this.taskCount});
}

class CategoryManagementPage extends StatefulWidget {
  @override
  _CategoryManagementPageState createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final List<Category> _categories = [];
  final TextEditingController _newCategoryController = TextEditingController();

  void _addCategory(String name) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama kategori tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      _categories.add(Category(name: name, taskCount: 0));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kategori "$name" berhasil ditambahkan')),
    );

    _newCategoryController.clear();
  }

  void _editCategory(int index, String newName) {
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama kategori tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      _categories[index].name = newName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kategori berhasil diperbarui menjadi "$newName"')),
    );
  }

  void _deleteCategory(int index) {
    String deletedCategory = _categories[index].name;

    setState(() {
      _categories.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kategori "$deletedCategory" berhasil dihapus')),
    );
  }

  void _showEditCategoryDialog(int index) {
    final TextEditingController _editCategoryController =
        TextEditingController(text: _categories[index].name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Kategori'),
          content: TextField(
            controller: _editCategoryController,
            decoration: InputDecoration(labelText: 'Nama Kategori'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _editCategory(index, _editCategoryController.text);
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Kategori'),
          content: Text('Apakah Anda yakin ingin menghapus kategori ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteCategory(index);
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kelola Kategori')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  title: Text(category.name),
                  subtitle: Text('Jumlah Tugas: ${category.taskCount}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditCategoryDialog(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmationDialog(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Nama Kategori Baru',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => _addCategory(_newCategoryController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
