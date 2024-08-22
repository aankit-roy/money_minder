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
    print('Database path ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++: $path');  // Add this line
    return openDatabase(
      path, version: 3,
      onCreate: _onCreate,

      onUpgrade: _onUpgrade
    );
  }


  Future<void> _onCreate(Database db, int version) async {
    print(' its time to create second database **********************((((((((((((((((((((((((((((((( Creating database and tables');
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
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Adding the new categories
      await _insertInitialData(db);
    }
  }




  Future<void> _insertInitialData(Database db) async {
    final List<CategoryData> categories = [
      CategoryData(name: 'Salary', icon: Icons.monetization_on, color: Colors.green),
      CategoryData(name: 'Investment Returns', icon: Icons.trending_up, color: Colors.blue),
      CategoryData(name: 'Gifts', icon: Icons.card_giftcard, color: Colors.pink),
      CategoryData(name: 'Freelance Work', icon: Icons.work, color: Colors.orange),
      CategoryData(name: 'Rental Income', icon: Icons.house, color: Colors.teal),
      CategoryData(name: 'Dividends', icon: Icons.attach_money, color: Colors.amber),
      CategoryData(name: 'Interest', icon: Icons.savings, color: Colors.cyan),
      CategoryData(name: 'Royalties', icon: Icons.music_note, color: Colors.purple),
      CategoryData(name: 'Bonuses', icon: Icons.star, color: Colors.red),
      CategoryData(name: 'Refunds', icon: Icons.undo, color: Colors.indigo),
      CategoryData(name: 'Side Hustles', icon: Icons.local_activity, color: Colors.deepOrange),
      CategoryData(name: 'Stock Sales', icon: Icons.show_chart, color: Colors.blueGrey),
      CategoryData(name: 'Consulting Fees', icon: Icons.business_center, color: Colors.deepPurple),
      CategoryData(name: 'Sales Commission', icon: Icons.trending_up, color: Colors.lightBlue),
      CategoryData(name: 'Cashback Rewards', icon: Icons.credit_card, color: Colors.yellow),
      CategoryData(name: 'Lottery Winnings', icon: Icons.attach_money, color: Colors.orangeAccent),
      CategoryData(name: 'Rental Rebate', icon: Icons.home, color: Colors.brown),
      CategoryData(name: 'Crowdfunding', icon: Icons.people, color: Colors.lime),
      CategoryData(name: 'Patent Royalties', icon: Icons.lightbulb, color: Colors.amberAccent),
      CategoryData(name: 'Earnings from Ads', icon: Icons.ads_click, color: Colors.blueAccent),
      CategoryData(name: 'App Earnings', icon: Icons.app_registration, color: Colors.greenAccent),
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

  Future<void> updateIncomesSameCategoryTransactionBySameDate(AddTransactionsData transaction) async {
    final db = await database;

    // Only update the amount, do not alter category or date
    await db.update(
      'transactions',
      {
        'amount': transaction.expensesPrice,
      },
      where: 'id = ?',
      whereArgs: [transaction.id],
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
