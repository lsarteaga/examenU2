import 'dart:io';
import 'package:examenu2/models/person_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  Future<Database> initDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    final path = join(appDir.path, 'personas.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Persons(
          time TEXT,
          id  INTEGER PRIMARY KEY,
          cardId TEXT,
          name TEXT,
          surname TEXT,
          birthDate TEXT,
          discapacity TEXT
        )      
      ''');
    });
  }

  Future<int> create(PersonModel newPerson) async {
    final db = await database;
    final newId = await db.insert('Persons', newPerson.toJson());
    return newId;
  }

  Future<dynamic> list() async {
    final db = await database;
    final result = await db.query('Persons');
    return result.isNotEmpty
        ? result.map((t) => PersonModel.fromJson(t)).toList()
        : [];
  }
}
