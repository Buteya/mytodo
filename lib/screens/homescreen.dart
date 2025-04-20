import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool onEdit = false;
  bool onTitle = false;
  bool checked = false;
  bool textFieldOn = false;
  bool onTitleEdit = false;
  String title = 'Todo';
  List<String> todo = ['Todo'];
  List<String> done = [];
  TextEditingController todoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  void addToDone(String clearedToDo, int index) {
    done.add(clearedToDo);
    todo.removeAt(index);
    setState(() {
      checked = true;
    });

    print(index);
  }

  void createToDo(String newTodo) {
    todo.add(newTodo);
  }

  void deleteTodo(int index) {
    todo.removeAt(index);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            textFieldOn = true;
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: Column(
        children: [
          onTitle
              ? Text(title)
              : onTitleEdit?TextField(controller: titleController,onEditingComplete: (){
                setState(() {
                  onTitle = true;
                  onTitleEdit = false;
                  title = titleController.text;
                });
          },):InkWell(
                onTap: (){
                  setState(() {
                    onTitleEdit = true;
                  });
                },
                child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.grey,
                      ),
                      Text(
                        'Title',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
              ),
          textFieldOn
              ? TextField(
                  controller: todoController,
                  autofocus: true,
                  onSubmitted: (value) {
                    createToDo(todoController.text);
                    setState(() {
                      textFieldOn = false;
                    });
                    todoController.clear();
                  },
                )
              : SizedBox(),
          Flexible(
            child: ListView.builder(
              itemCount: todo.length,
              itemBuilder: (context, index) {
                TextEditingController editTodo = TextEditingController(text:todo[index]);
                return Dismissible(
                  key: Key(index.toString()),
                  background: Container(
                    color: Colors.red,
                    child: ListTile(
                      trailing: Icon(
                        Icons.delete_forever_rounded,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      deleteTodo(index);
                    });
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (checked) => addToDone(todo[index], index),
                    ),
                    title: onEdit ? TextField(
                      controller: editTodo,
                      onEditingComplete: (){
                        setState(() {
                          todo[index] = editTodo.text;
                          onEdit = false;
                        });
                      },
                    ) : InkWell(onTap:(){
                      setState(() {
                        onEdit = true;
                      });
                    },child: Text(todo[index])),
                    trailing: IconButton(
                      onPressed: (){
                        setState(() {
                          deleteTodo(index);
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
                itemCount: done.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: done[index],
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
