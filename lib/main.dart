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
  static const todos = ["Test", "Test2", "Test3"];

  void _removeItem(int index) {}

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
                style: const TextStyle(fontSize: 24, color: Colors.red)),
            onTap: () => {
              setState(() {
                todos[index] = "NewTest";
              })
            },
          );
        },
      ),
    );
  }
}
