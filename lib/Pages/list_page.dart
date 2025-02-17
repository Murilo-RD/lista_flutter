import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Models/todo.dart';
import '../widgets/todo_list_item.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController todosController = TextEditingController();

  List<Todo> todos = [];

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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todosController,
                      style: TextStyle(color: Colors.white54),
                      decoration: InputDecoration(
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
                      onPressed: () {
                        String text = todosController.text;
                        if(todosController.text.isNotEmpty){
                        setState(() {
                          Todo newTodo = Todo(title: text, date: DateTime.now());
                          todos.add(newTodo);
                        });
                        todosController.clear();
                        }
                      },
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
                      TodoListItem(todo:todo),
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
                    onPressed: () {
                      setState(() {
                        todos.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
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
