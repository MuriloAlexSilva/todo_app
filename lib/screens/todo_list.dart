import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/Todo.dart';
import 'package:todo_app/screens/todo_item.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> list = [];
  final _doneStyle =
      TextStyle(color: Colors.green, decoration: TextDecoration.lineThrough);

  @override
  void initState() {
    super.initState();
    _reloadList();
  }

  _reloadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('list');
    if (data != null) {
      setState(() {
        var objs = jsonDecode(data) as List;
        list = objs.map((obj) => Todo.fromJson(obj)).toList();
      });
    }
  }

  _removeItem(int index) {
    setState(() {
      list.removeAt(index);
    });
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('list', jsonEncode(list)));
  }

  _doneItem(int index) {
    setState(() {
      list[index].status = 'F';
    });
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('list', jsonEncode(list)));
  }

  _showAlertDialog(BuildContext context, String conteudo,
      Function confirmFunction, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text(conteudo),
          actions: [
            FlatButton(
              child: Text('Não'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                confirmFunction(index);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Todo App'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${list[index].titulo}',
                style: list[index].status == 'F' ? _doneStyle : null),
            subtitle: Text('${list[index].descricao}',
                style: list[index].status == 'F' ? _doneStyle : null),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TodoItem(todo: list[index], index: index),
                )).then((value) => _reloadList()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _showAlertDialog(context,
                      'Confirma a exclusão deste item?', _removeItem, index),
                ),
                Visibility(
                  visible: list[index].status == 'A',
                  child: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () => _showAlertDialog(context,
                        'Confirma a finalização deste item?', _doneItem, index),
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoItem(todo: null, index: -1),
            )).then((value) => _reloadList()),
      ),
    );
  }
}
