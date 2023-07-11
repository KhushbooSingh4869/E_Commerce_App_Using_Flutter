import 'package:ecommerce/catalog.dart';
import 'package:ecommerce/signup.dart';
import 'package:ecommerce/login.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'cart_page.dart';


void main() {
  runApp(
    EcommerceApp(),
  );
}

class DatabaseHelper {
  static final _databaseName = 'my_database.db';
  static final _databaseVersion = 1;

  static final table = 'users';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnPassword = 'password';

  // Define the create table SQL statement
  static final String createTableQuery = '''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnEmail TEXT NOT NULL,
      $columnPassword TEXT NOT NULL
    )
  ''';

  // Define the singleton instance
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._private();

  DatabaseHelper._private();

  // Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create the users table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(createTableQuery);
  }

  // Insert a new user into the database
  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert(table, user.toMap());
  }

  // Fetch a user from the database based on email
  Future<User?> getUser(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnEmail = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }

    return null;
  }

}

class User {
  int? id;
  String name;
  String email;
  String password;

  User({this.id, required this.name, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnEmail: email,
      DatabaseHelper.columnPassword: password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[DatabaseHelper.columnId],
      name: map[DatabaseHelper.columnName],
      email: map[DatabaseHelper.columnEmail],
      password: map[DatabaseHelper.columnPassword],
    );
  }
}

class EcommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),
        '/catalog' : (context) => ListPage(),
        '/cart_page': (context) => CartPage(),
      },
    );
  }
}


