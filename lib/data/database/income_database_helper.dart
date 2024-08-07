import 'package:flutter/material.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class IncomeDatabaseHelper {
  static final IncomeDatabaseHelper _instance = IncomeDatabaseHelper._internal();

  factory IncomeDatabaseHelper() {
    return _instance;
  }

  IncomeDatabaseHelper._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'income_minder.db');
    return openDatabase(
      path, version: 1,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        icon TEXT,
        color INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        amount REAL,
        date TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    final List<CategoryData> categories = [
      CategoryData(name: 'Salary', icon: Icons.monetization_on, color: Colors.green),
      CategoryData(name: 'Investment Returns', icon: Icons.trending_up, color: Colors.blue),
      CategoryData(name: 'Gifts', icon: Icons.card_giftcard, color: Colors.pink),
      // Add more categories as needed
    ];

    List<Map<String, dynamic>> categoryMaps =
    categories.map((category) => category.toMap()).toList();

    categoryMaps.forEach((categoryMap) async {
      await db.insert('categories', categoryMap);
    });
  }

  Future<void> insertCategory(Map<String, dynamic> category) async {
    Database db = await database;
    await db.insert('categories', category);
  }

  Future<List<CategoryData>> getCategories() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return CategoryData.fromMap(maps[i]);
    });
  }

  Future<void> insertTransaction(AddTransactionsData transaction) async {
    Database db = await database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<List<Map<String, dynamic>>> getTransactionsWithCategory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT transactions.*, categories.name AS name, categories.icon AS icon, categories.color AS color
      FROM transactions
      INNER JOIN categories ON transactions.category_id = categories.id
    ''');
    return maps;
  }

  Future<void> updateTransaction(AddTransactionsData transaction) async {
    final db = await database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<AddTransactionsData>> getTransactionsByCategoryAndDate(
      String categoryName, DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'name = ? AND date(date) = ?',
      whereArgs: [categoryName, dateStr],
    );
    return maps.map((e) => AddTransactionsData.fromMap(e)).toList();
  }
}
