import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_item.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var list = ["teste 1", "teste 2", "teste 3"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(list[index]),
            subtitle: Text(list[index]),
            onTap: () => Navigator.push(
                //NAvigator.push - ir para outra tela
                context,
                //MaterialPageRoute para chamar a outra tela
                MaterialPageRoute(
                    builder: (context) =>
                        TodoItem() //Qual Widget abrir da tela,
                    )),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: list.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoItem(),
            )),
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
