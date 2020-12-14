import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './Todotype.dart';
import './Storage.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter;
  DataBase todoitem = DataBase();
  List<Todo> list_of_todo = [];

  @override
  void initState() {
    super.initState();
    _counter = 0;
    todoitem.init();
    // todoitem.cleanAll();
    // list_of_todo = await todoitem.getItem();
  }

  _incrementCounter() async {
    log('CLIC');
    final value = Todo(
      desc: 'hello_world',
      title: 'ceci est un titre',
      done: 0,
    );
    todoitem.insertItem(value);
    list_of_todo = await todoitem.getItem();
    if (list_of_todo.length >= 10) {
      todoitem.cleanAll();
    }
    // list_of_todo = todoitem.getItem();
    // print(await list_of_todo);
    // print(await todoitem.getItem());
    // todoitem.cleanAll();
    // final value = await todoitem.getItem();
    // for (var item in value) {
    //   todoitem.deleteItem(item.id);
    // }
    // print(list_of_todo);
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: 100,
            ),
            for (var item in list_of_todo) Text(item.toString())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
