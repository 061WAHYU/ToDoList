import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';  // Needed for the Color class
import 'package:todolist/models/category_model.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Private constructor
  DatabaseHelper._internal();

  // Factory constructor to return the singleton instance
  factory DatabaseHelper() => _instance;

  // Database object
  Database? _database;

  // Getter to return the database, creating it if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date TEXT,
        time TEXT,
        priority TEXT,
        category TEXT,
        reminder INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        iconPath TEXT,
        boxColor INTEGER
      )
    ''');
  }

  // Category CRUD operations
  Future<List<CategoryModel>> getCategories() async {
    Database db = await database;
    var categories = await db.query('categories', orderBy: 'name');
    List<CategoryModel> categoryList = categories.isNotEmpty
        ? categories.map((c) => CategoryModel.fromMap(c)).toList()
        : [];
    return categoryList;
  }

  Future<int> insertCategory(CategoryModel category) async {
    Database db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<int> updateCategory(CategoryModel category) async {
    Database db = await database;
    return await db.update('categories', category.toMap(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    Database db = await database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // Task CRUD operations remain unchanged
  Future<int> insertTask(Map<String, dynamic> task) async {
    Database db = await database;
    return await db.insert('tasks', task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    Database db = await database;
    return await db.query('tasks');
  }

  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    Database db = await database;
    return await db.update('tasks', task, where: 'id = ?', whereArgs: [task['id']]);
  }
}
