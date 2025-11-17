import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/person.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'app.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE users(
id INTEGER PRIMARY KEY AUTOINCREMENT,
username TEXT NOT NULL,
email TEXT NOT NULL UNIQUE,
password TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE persons(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
email TEXT NOT NULL,
age INTEGER NOT NULL,
dob TEXT
)
''');
  }

  // -------- Users CRUD (signup/login) --------

  Future<int> insertUser(User user) async {
    final database = await db;
    return await database.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final database = await db;
    final res = await database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final database = await db;
    final res = await database.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  // -------- Persons CRUD --------

  Future<int> insertPerson(Person person) async {
    final database = await db;
    return await database.insert('persons', person.toMap());
  }

  Future<List<Person>> getAllPersons({String? query}) async {
    final database = await db;
    List<Map<String, dynamic>> res;
    if (query != null && query.isNotEmpty) {
      res = await database.query(
        'persons',
        where: 'name LIKE ? OR email LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
    } else {
      res = await database.query('persons');
    }
    return res.map((m) => Person.fromMap(m)).toList();
  }

  Future<int> updatePerson(Person person) async {
    final database = await db;
    return await database.update(
      'persons',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  Future<int> deletePerson(int id) async {
    final database = await db;
    return await database.delete('persons', where: 'id = ?', whereArgs: [id]);
  }
}
