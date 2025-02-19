import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista/Repositorie/todo_repository.dart';

import '../Models/todo.dart';
import '../widgets/todo_list_item.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController todosController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  List<Todo> todos = [];

  void todoAdd() {
    String text = todosController.text;
    if (todosController.text.isNotEmpty) {
      setState(() {
        Todo newTodo = Todo(title: text, date: DateTime.now());
        todos.add(newTodo);
        errorText = null;
      });
      todosController.clear();
      todoRepository.saveTodoList(todos);
    } else {
      setState(() {
        errorText = 'O Titulo eta vazio!';
      });
    }
  }

  String? errorText;
  Todo? deletedTodo;
  int? deletedTodoPos;

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });

    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa (${todo.title}) foi removida com sucesso',
          style: TextStyle(
            color: Colors.white54,
          ),
        ),
        backgroundColor: Colors.white12,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.red,
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeletTodosConfirmationDialog() {
    if (todos.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Limpar Tudo!',
            style: TextStyle(color: Colors.white54),
          ),
          content: Text(
            'Você tem certeza que deseja apagar TODAS as tarefas?',
            style: TextStyle(color: Colors.white54),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  todos.clear();
                  todoRepository.saveTodoList(todos);
                });
              },
              child: Text(
                'Limpar Tudo',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      todos = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Lista De Tarefas",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (String value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            Todo newTodo =
                                Todo(title: value, date: DateTime.now());
                            todos.add(newTodo);
                            todosController.clear();
                            todoRepository.saveTodoList(todos);
                            errorText = null;
                          });
                        } else {
                          setState(() {
                            errorText = 'O Titulo eta vazio!';
                          });
                        }
                      },
                      controller: todosController,
                      style: TextStyle(color: Colors.white54),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.purple,
                          ),
                        ),
                        errorText: errorText,
                        border: OutlineInputBorder(),
                        counterStyle: TextStyle(color: Colors.white),
                        labelText: 'Adicione Uma Tarefa',
                        labelStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        hintText: 'Ex. Compras',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                      onPressed: todoAdd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white70,
                      )),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        onDelete: onDelete,
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Você Possui Tarefas ${todos.length} Pendentes',
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: showDeletTodosConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          todos.isNotEmpty ? Colors.purple : Colors.white12,
                      padding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Limpar Tudo',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
