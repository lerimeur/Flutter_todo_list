import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer';
import './Todotype.dart';

class DataBase {
  Future<Database> database;

  void init() async {
    log('INIT');
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'todos.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT,done INTEGER)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> cleanAll() async {
    log('CLEAN ALL');
    final value = await getItem();
    if (value.length > 0) {
      for (var item in value) {
        deleteItem(item.id);
      }
    }
  }

  Future<void> insertItem(Todo todo) async {
    log('INSERT ITEM');
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Todo>> getItem() async {
    log('GET ALL ITEM');
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('todos');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['name'],
        desc: maps[i]['desc'],
        done: maps[i]['done'],
      );
    });
  }

  Future<void> updateItem(Todo todo) async {
    log('UPDATE ITEM');
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'todos',
      todo.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteItem(int id) async {
    log('DEL ONE ITEM');
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'todos',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}

// void main() async {
//   // Avoid errors caused by flutter upgrade.
//   // Importing 'package:flutter/widgets.dart' is required.
//   WidgetsFlutterBinding.ensureInitialized();
//   // Open the database and store the reference.
//   final Future<Database> database = openDatabase(
//     // Set the path to the database. Note: Using the `join` function from the
//     // `path` package is best practice to ensure the path is correctly
//     // constructed for each platform.
//     join(await getDatabasesPath(), 'doggie_database.db'),
//     // When the database is first created, create a table to store dogs.
//     onCreate: (db, version) {
//       return db.execute(
//         "CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, desc TEXT,fait INTEGER)",
//       );
//     },
//     // Set the version. This executes the onCreate function and provides a
//     // path to perform database upgrades and downgrades.
//     version: 1,
//   );

//   Future<List<Todo>> getItem() async {
//     // Get a reference to the database.
//     final Database db = await database;

//     // Query the table for all The Dogs.
//     final List<Map<String, dynamic>> maps = await db.query('todos');

//     // Convert the List<Map<String, dynamic> into a List<Dog>.
//     return List.generate(maps.length, (i) {
//       return Todo(
//         id: maps[i]['id'],
//         title: maps[i]['name'],
//         desc: maps[i]['desc'],
//         done: maps[i]['done'],
//       );
//     });
//   }

//   Future<void> updateItem(Todo todo) async {
//     // Get a reference to the database.
//     final db = await database;

//     // Update the given Dog.
//     await db.update(
//       'todos',
//       todo.toMap(),
//       // Ensure that the Dog has a matching id.
//       where: "id = ?",
//       // Pass the Dog's id as a whereArg to prevent SQL injection.
//       whereArgs: [todo.id],
//     );
//   }

//   Future<void> deleteItem(int id) async {
//     // Get a reference to the database.
//     final db = await database;

//     // Remove the Dog from the database.
//     await db.delete(
//       'todos',
//       // Use a `where` clause to delete a specific dog.
//       where: "id = ?",
//       // Pass the Dog's id as a whereArg to prevent SQL injection.
//       whereArgs: [id],
//     );
//   }

//   var fido = Todo(
//     id: 0,
//     title: 'fido',
//     desc: 'hello world',
//     done: 0,
//   );

//   // Insert a dog into the database.
//   await insertItem(fido);

//   // Print the list of dogs (only Fido for now).
//   print(await getItem());

//   // Update Fido's age and save it to the database.
//   fido = Todo(
//     id: fido.id,
//     title: fido.title,
//     desc: fido.desc,
//     done: fido.done + 1,
//   );
//   await updateItem(fido);

//   // Print Fido's updated information.
//   print(await getItem());

//   // Delete Fido from the database.
//   await deleteItem(fido.id);

//   // Print the list of dogs (empty).
//   print(await getItem());
// }
