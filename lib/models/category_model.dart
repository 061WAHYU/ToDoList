import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todolist/screens/create.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;
  Widget Page;

  CategoryModel(
      {required this.name,
      required this.iconPath,
      required this.boxColor,
      required this.Page});

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(CategoryModel(
        name: 'Create',
        iconPath: 'assets/icon/cccc.svg',
        boxColor: Color(0xff92A3FD),
        Page: CreateTaskPage()));
    categories.add(CategoryModel(
        name: 'Open',
        iconPath: 'assets/icon/oo.svg',
        boxColor: Color(0xff92A3FD),
        Page: CreateTaskPage()));
    categories.add(CategoryModel(
        name: 'Category',
        iconPath: 'assets/icon/ccc.svg',
        boxColor: Color(0xff92A3FD),
        Page: CreateTaskPage()));
    return categories;
  }
}
