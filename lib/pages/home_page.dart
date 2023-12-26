import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todolist/data/database.dart';
import 'package:todolist/widgets/button.dart';
import 'package:todolist/widgets/list_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mybox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  final _textcontroller = TextEditingController();
  @override
  void initState() {
    if (_mybox.get("TODOLIST") == null) {
      db.initData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 69, 214, 214),
          elevation: 0,
          title: const Text("To Do List"),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: db.toDoList.length,
            itemBuilder: ((context, index) {
              return ListItems(
                taskName: db.toDoList[index][0],
                taskCompleted: db.toDoList[index][1],
                onchanged: (value) => checkboxChanged(value, index),
                deleteItem: (context) => deleteTask(index),
              );
            })),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void checkboxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    controller: _textcontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Add a new task",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyButton(text: "Save", onPressed: saveNewTask),
                      const SizedBox(
                        width: 8,
                      ),
                      MyButton(
                          text: "Cancel",
                          onPressed: () => Navigator.of(context).pop()),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_textcontroller.text, false]);
      _textcontroller.clear();
    });
    db.updateDataBase();
    Navigator.of(context).pop();
  }

  deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }
}
