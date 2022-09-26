import 'package:circle_checkbox/redev_checkbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/widgets/dialog.dart';

import '../item.dart';
import '../widgets/dialog2.dart';
import 'home_controller.dart';

enum TodoOption {
  az,
  neweset,
  done,
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  HomeController get _read => context.read<HomeController>();

  HomeController get _watch => context.watch<HomeController>();

  final searchController = TextEditingController();
  late String search = searchController.text;

  bool sort = false;
  late final TabController tabController;

  DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Center(
        //   child: Text('Todo-App'),
        // ),
        title: IconButton(
          icon: Icon(CupertinoIcons.paintbrush_fill),
          onPressed: (){
            setState(() {
              _read.checkColor = !_read.checkColor;
            });
          },
        ),
        backgroundColor: (_read.checkColor == false) ? const Color(0xff6a5ffd) : const Color(0xfff99ff7),
        actions: <Widget>[
          PopupMenuButton(
              // onSelected: (){},
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('A-Z'),
                      value: TodoOption.az,
                      onTap: _read.az,
                    ),
                    PopupMenuItem(
                      child: Text('Newest'),
                      value: TodoOption.neweset,
                      onTap: _read.newest,
                    ),
                    PopupMenuItem(
                      child: Text('Done'),
                      value: TodoOption.done,
                      onTap: _read.done,
                    ),
                  ])
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: tabController,
          children: [
            Consumer<HomeController>(
              builder: (context, todos, child) {
                if (todos.todoList.isEmpty) {
                  return Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image(
                            image:
                            (_read.checkColor == false) ?
                            AssetImage('assets/images/handd.png')
                            : AssetImage('assets/images/handdd.png') ,
                            fit: BoxFit.cover,
                            color: Colors.white.withOpacity(0.9),
                            colorBlendMode: BlendMode.modulate,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: ListView.builder(
                      itemCount: todos.todoList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xfff4f9fc)),
                          child: ListTile(
                            onTap: () {
                              AlertDialog alert = AlertDialog(
                                title: Text('Your work:   ' +
                                    todos.todoList[index].title),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Date: ' +
                                            dateFormat.format(DateTime.parse(
                                                todos.todoList[index].date)),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        'Description: ' +
                                            todos.todoList[index].description,
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                              // print(todos.todoList[index].isDone);
                            },
                            leading: Consumer<Todo>(
                              builder: (context, todo, child) => IconButton(
                                onPressed: () {
                                  print(todo.isDone);

                                  todo.doneStatus();
                                },
                                // IconButton(
                                icon: Icon(
                                  todo.isDone
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  size: 25,
                                ),
                                color: Colors.grey,
                              ),
                            ),
                            title: Consumer<Todo>(
                              builder: (context, todo, child) => Text(
                                todos.todoList[index].title,
                                style: todo.isDone
                                    ? TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : TextStyle(
                                        color: Colors.black87,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                              ),
                            ),
                            trailing: Wrap(
                              spacing: 5,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DialogWidget2(index: index);
                                          });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.pencil,
                                      color: Color(0xffbdc4cc),
                                    )),
                                IconButton(
                                    onPressed: () {
                                      todos.delete(todos.getTodo[index]);
                                    },
                                    icon: Icon(CupertinoIcons.trash_fill,
                                        color: Color(0xffbdc4cc))),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        label: Text("Seacrh by title"),
                      ),
                      onChanged: (value) => _read.findWithTitle(value),
                    ),
                  ),
                  Expanded(
                    child: Consumer<HomeController>(
                      builder: (context, controller, child) {
                        if (controller.searchResult.isEmpty) {
                          return const Center(
                              child: Text(
                            'Nothing here',
                            style: TextStyle(
                                color: Color(0xffbdc4cc),
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ));
                        }
                        print(controller.searchResult.length);
                        return ListView.builder(
                          itemCount: controller.searchResult.length,
                          itemBuilder: (context, i) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xfff4f9fc)),
                              child: ListTile(
                                onTap: () {
                                  AlertDialog alert = AlertDialog(
                                    title: Text('Your work:   ' +
                                        controller.searchResult[i].title),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Date: ' +
                                                controller.searchResult[i].date,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            'Description: ' +
                                                controller.searchResult[i]
                                                    .description,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                },
                                title: Consumer<Todo>(
                                  builder: (context, todo, child) => Text(
                                    'Title : ' +
                                        controller.searchResult[i].title,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(CupertinoIcons.plus),
          backgroundColor: (_read.checkColor == false) ? const Color(0xff786ffe) : const Color(0xffd970da),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return DialogWidget();
                });
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabController.index,
        backgroundColor: (_read.checkColor == false) ? const Color(0xff6a5ffd) : const Color(0xfff99ff7),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.3),
        onTap: (index) => tabController.animateTo(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}
