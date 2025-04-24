import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _onEdit = false;
  bool _onTitle = false;
  bool _checked = false;
  bool _textFieldOn = false;
  bool _onTitleEdit = false;
  String _title = 'Todo';
  final List<String> _todo = [];
  final List<String> _done = [];
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  void _addToDone(String clearedToDo, int index) {
    _done.add(clearedToDo);
    _todo.removeAt(index);
    setState(() {
      _checked = true;
    });
  }

  void _createToDo(String newTodo) {
    _todo.add(newTodo);
  }

  void _deleteTodo(int index) {
    _todo.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add a Todo',
        onPressed: () {
          setState(() {
            _textFieldOn = true;
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Todo App"),
      ),
      body: Column(
        children: [
          _onTitle
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                     setState(() {
                       _onTitle = false;
                       _onTitleEdit = true;
                     });
                    },
                    child: Text(
                      _title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              : _onTitleEdit
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8.0),
                      child: TextField(
                        controller: _titleController,
                        onEditingComplete: () {
                          setState(() {
                            _onTitle = true;
                            _onTitleEdit = false;
                            _title = _titleController.text;
                          });
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _onTitleEdit = true;
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
                    ),
          _textFieldOn
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  child: TextField(
                    controller: _todoController,
                    autofocus: true,
                    onSubmitted: (value) {
                      _createToDo(_todoController.text);
                      setState(() {
                        _textFieldOn = false;
                      });
                      _todoController.clear();
                    },
                  ),
                )
              : SizedBox(),
          Flexible(
            child: ListView.builder(
              itemCount: _todo.length,
              itemBuilder: (context, index) {
                TextEditingController editTodo =
                    TextEditingController(text: _todo[index]);
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
                      _deleteTodo(index);
                    });
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (checked) => _addToDone(_todo[index], index),
                    ),
                    title: _onEdit
                        ? TextField(
                            controller: editTodo,
                            onEditingComplete: () {
                              setState(() {
                                _todo[index] = editTodo.text;
                                _onEdit = false;
                              });
                            },
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                _onEdit = true;
                              });
                            },
                            child: Text(_todo[index])),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _deleteTodo(index);
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Divider(),
          ),
          Flexible(
            child: ListView.builder(
                itemCount: _done.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: InkWell(
                      onTap: () {
                        setState(() {
                          _todo.add(_done[index]);
                          _done.removeAt(index);
                        });
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _done[index],
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
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
