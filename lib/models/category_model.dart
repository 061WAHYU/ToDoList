import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:todolist/screens/category_page.dart';
import 'package:todolist/screens/create.dart';
import 'package:todolist/screens/ongoing_task.dart';

class CategoryModel {
  int? id; // ID for database
  String name;
  String iconPath;
  Color boxColor;
  Widget page; // Page to navigate to

  CategoryModel({
    this.id,
    required this.name,
    required this.iconPath,
    required this.boxColor,
    required this.page, // Include target page in the constructor
  });

  // Convert CategoryModel to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
      'boxColor': boxColor.value,
    };
  }

  // Create a CategoryModel from a map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      iconPath: map['iconPath'],
      boxColor: Color(map['boxColor']),
      page: _getPageFromName(map['name']), // Resolve the page from name
    );
  }

  // Dummy function to resolve page, replace with actual navigation logic
  static Widget _getPageFromName(String name) {
    switch (name) {
      case 'Create':
        return CreateTaskPage(); // Replace with actual import and page
      case 'Open':
        return OngoingTaskPage(); // Replace with actual import and page
      case 'Category':
        return CategoryPage(); // Replace with actual import and page
      default:
        return Placeholder(); // Placeholder for default case
    }
  }

  // Get list of predefined categories
  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        name: 'Create',
        iconPath: 'assets/icon/cccc.svg',
        boxColor: const Color(0xff92A3FD),
        page: CreateTaskPage(), // Target page for the category
      ),
      CategoryModel(
        name: 'Open',
        iconPath: 'assets/icon/oo.svg',
        boxColor: const Color(0xff92A3FD),
        page: OngoingTaskPage(), // Target page for the category
      ),
      CategoryModel(
        name: 'Category',
        iconPath: 'assets/icon/ccc.svg',
        boxColor: const Color(0xff92A3FD),
        page: CategoryPage(), // Target page for the category
      ),
    ];
  }
}
