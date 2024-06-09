import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MyTodoApp()));
}

class MyTodoApp extends StatefulWidget {
  const MyTodoApp({super.key});

  @override
  State<MyTodoApp> createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  List<String> todos = ["Test", "Test2", "Test3"];

  List<int> markedItemIndex = [];

  // void _removeItem(int index) {
  //   setState(() {
  //     todos.removeAt(index);
  //   });
  // }

  void _toggleItemMark(int index) {
    setState(() {
      markedItemIndex.contains(index)
          ? markedItemIndex.remove(index)
          : markedItemIndex.add(index);
    });
    print(markedItemIndex);
  }

  void _addItem(String text) {
    setState(() {
      todos.add(text);
    });
  }

  void _showInputDialog() {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController();

          return AlertDialog(
            title: const Text("Enter some text!"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Enter Some text'),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _addItem(controller.text);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "MyTodoApp",
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(todos[index],
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                  decoration: markedItemIndex.contains(index) ? TextDecoration.lineThrough : TextDecoration.none)),
              onTap: () => {_toggleItemMark(index)},
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showInputDialog,
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.add,
            color: Colors.red,
          ),
        ));
  }
}
