import 'package:flutter/material.dart';

class Todo with ChangeNotifier {
  String id;
  String title;
  String date;
  String description;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.isDone,
  });

  void doneStatus() {
    isDone = !isDone;
    notifyListeners();
  }
}
