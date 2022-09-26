import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Home/home_controller.dart';

class DialogWidget2 extends StatefulWidget {
  final int index;
  const DialogWidget2({Key? key, required this.index}) : super(key: key);

  @override
  State<DialogWidget2> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget2> {
  HomeController get _read => context.read<HomeController>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  late String title = titleController.text;
  late String description = descriptionController.text;
  late String date = dateController.text;

  DateTime todoDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  datePicker() async{
    final DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2050)
    );
    if(dateTime != null){
      setState(() {
        todoDate = dateTime;
      });
    }
    date = dateFormat.format(todoDate);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Todo', style: TextStyle(color: (_read.checkColor == false) ? const Color(0xff786ffe) : const Color(0xffd970da))),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: _read.todoList[widget.index].title,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: _read.todoList[widget.index].description,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              onTap: datePicker,
              controller: dateController,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: dateFormat
                    .format(DateTime.parse(_read.todoList[widget.index].date)),
              ),
            ),

          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (title == '' || date == '' || description == '') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Don't empty"),
                  duration: Duration(seconds: 1),
                ));
                Navigator.pop(context);
              } else {
                _read.update(
                    widget.index, title, todoDate.toString(), description);
                Navigator.pop(context);
              }
            },
            child: Text('Update', style: TextStyle(color: (_read.checkColor == false) ? const Color(0xff786ffe) : const Color(0xffd970da)))),
      ],
    );
  }
}
