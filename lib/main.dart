import 'package:flutter/material.dart';

enum TodoStatus {
  todo,
  done,
  removed,
}

void main() {
  runApp(const MaterialApp(home: MyTodoApp()));
}

class MyTodoApp extends StatefulWidget {
  const MyTodoApp({super.key});

  @override
  State<MyTodoApp> createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  List<Todo> todos = [
    Todo(
        name: "Plant a vegetable garden",
        description: "Plant tomatoes, carrots, and lettuce in the backyard",
        status: TodoStatus.todo),
    Todo(
        name: "Fix the leaky faucet",
        description:
            "Replace the washer and check the faucet for any other issues",
        status: TodoStatus.todo),
    Todo(
        name: "Organize the garage",
        description:
            "Sort tools, dispose of unused items, and set up new storage shelves",
        status: TodoStatus.todo),
    Todo(
        name: "Clean the gutters",
        description: "Remove debris from the gutters and check for any damage",
        status: TodoStatus.todo),
    Todo(
        name: "Install new light fixtures",
        description:
            "Replace old fixtures with modern ones in the living room, kitchen, and bedroom",
        status: TodoStatus.todo),
  ];

  void _removeItem(Todo todo) {
    setState(() {
      todos.remove(todo);
    });
  }

  void _toggleItemMark(TodoStatus status, int hashCode) {
    setState(() {
      todos = todos.map((t) {
        if (t.hashCode == hashCode) {
          t.status = status;
        }
        return t;
      }).toList();
    });
  }

  void _onShowTodoDetail(Todo todo) async {
    final action = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TodoDetailScreen(todo: todo)));

    setState(() {
      switch (action) {
        case TodoStatus.todo:
          _toggleItemMark(action, todo.hashCode);
          break;
        case TodoStatus.done:
          _toggleItemMark(action, todo.hashCode);
          break;
        case TodoStatus.removed:
          _removeItem(todo);
          break;
      }
    });
  }

  void _addItem(Todo todo) {
    setState(() {
      todos.add(todo);
    });
  }

  void _showInputDialog() {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController titleController = TextEditingController();
          TextEditingController descriptionController = TextEditingController();

          return AlertDialog(
            title: const Text("Enter some text!"),
            content: SizedBox(
              width: 350,
              height: 200,
              child: Column(children: [
                const SizedBox(height: 40),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Enter a title"),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: descriptionController,
                  decoration:
                      const InputDecoration(hintText: "Enter a description"),
                )
              ]),
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
                      if (titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty) {
                        _addItem(Todo(
                            name: titleController.text,
                            description: descriptionController.text,
                            status: TodoStatus.todo));
                        Navigator.of(context).pop();
                      }
                    });
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
            title: Text(
              todos[index].name,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  decoration: todos[index].status == TodoStatus.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            onTap: () {
              _onShowTodoDetail(todos[index]);
            },
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
      ),
    );
  }
}

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  const TodoDetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.name),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    todo.description,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 0),
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    todo.status == TodoStatus.todo
                        ? "No completed"
                        : "Completed",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      todo.status == TodoStatus.todo
                          ? Navigator.pop(context, TodoStatus.done)
                          : Navigator.pop(context, TodoStatus.todo);
                    },
                    child:
                        Text(todo.status == TodoStatus.todo ? "Done" : "Undo")),
                const SizedBox(width: 15),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, TodoStatus.removed);
                    },
                    child: const Text("Remove"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Todo {
  String name;

  String description;

  TodoStatus status;

  Todo({required this.name, required this.description, required this.status});

  set setName(String name) {
    this.name = name;
  }

  set setDescription(String description) {
    description = description;
  }

  set setStatus(TodoStatus status) {
    status = status;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Todo &&
        other.name == name &&
        other.description == description &&
        other.status == status;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ status.hashCode;

  @override
  String toString() {
    return 'Todo{_name: $name, _description: $description, _status: $status}';
  }
}
