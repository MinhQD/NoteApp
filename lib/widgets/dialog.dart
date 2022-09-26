import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Home/home_controller.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({Key? key}) : super(key: key);

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
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
      title: Text(
        'Todo',
        style:
            TextStyle(color:
            (_read.checkColor == false) ? const Color(0xff786ffe) : const Color(0xffd970da), fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: 'Title',
                  label: Text(
                    'Title',
                    style: TextStyle(color: (_read.checkColor == false) ? const Color(0xff786ffe) : const Color(0xffd970da)),
                  )),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: 'Description',
                  label: Text(
                    'Description',
                    style: TextStyle(color: (_read.checkColor == false) ? const Color(0xff786ffe) : const Color(0xffd970da)),
                  )),
            ),
            SizedBox(height: 10),
            TextField(
              onTap: datePicker,
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: dateFormat.format(todoDate),
                  label: Text(
                    'Date',
                    style: TextStyle(color: (_read.checkColor == false) ? const Color(0xff786ffe) : const Color(0xffd970da)),
                  )),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (title == '' || date == ''|| description == '') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Don't empty"),
                  duration: Duration(seconds: 1),
                ));
                Navigator.pop(context);
              } else {
                _read.addTodo2(title, todoDate.toString(), description);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Add',
              style: TextStyle(
                  color: (_read.checkColor == false) ? const Color(0xff786ffe) : const Color(0xffd970da), fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
