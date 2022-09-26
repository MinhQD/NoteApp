import 'package:flutter/material.dart';

import '../models/todo.dart';

class HomeController with ChangeNotifier {
  final List<Todo> todoList = <Todo>[];
  List<Todo> get getTodo => todoList;

  List<Todo> searchResult = [];

  bool checkColor = false;

  void addTodo2(String title, String date, String description) {
      final todolist = Todo(
        id: DateTime.now().toString(),
        title: title,
        date: date.toString(),
        description: description,
        isDone: false,
      );
      todoList.add(todolist);
      notifyListeners();
    }

  void delete(Todo todo) {
    todoList.remove(todo);
    notifyListeners();
  }

  void update(int i, String title,String date, String description) {
    todoList[i].title = title;
    todoList[i].date = date;
    todoList[i].description = description;
    notifyListeners();
  }

  void az() {
    todoList.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  void newest() {
    todoList
        .sort((a, b) => DateTime.parse(b.id).compareTo(DateTime.parse(a.id)));
    notifyListeners();
  }

  void done() {
    todoList.where((element) => element.isDone ? false : true).toList();
    notifyListeners();
  }

  void load(){
    notifyListeners();
  }

  void findWithTitle(String search) {
      searchResult = todoList.where((element) => element.title == search).toList();
      notifyListeners();
  }

  Todo? findByTitle(String? title) {
    return todoList.firstWhere((element) => element.title == title);
  }
}
