import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();
  static Database? _database;
// if already database return _database other wise create new by calling _initDatabase
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

// creating new database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'money_minder.db');
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
      CategoryData(name: 'Rent', icon: Icons.home, color: Colors.blue),
      CategoryData(
          name: 'Utilities', icon: Icons.lightbulb, color: Colors.orange),
      CategoryData(
          name: 'Groceries', icon: Icons.shopping_cart, color: Colors.green),
      CategoryData(
          name: 'Transportation',
          icon: Icons.directions_car,
          color: Colors.red),
      CategoryData(
          name: 'Dining Out', icon: Icons.restaurant, color: Colors.purple),
      CategoryData(
          name: 'Entertainment', icon: Icons.movie, color: Colors.teal),
      CategoryData(
          name: 'Subscriptions',
          icon: Icons.subscriptions,
          color: Colors.amber),
      CategoryData(
          name: 'Clothing', icon: Icons.shopping_bag, color: Colors.pink),
      CategoryData(
          name: 'Fitness', icon: Icons.fitness_center, color: Colors.brown),
      CategoryData(name: 'Education', icon: Icons.school, color: Colors.cyan),
      CategoryData(name: 'Books ', icon: Icons.book, color: Colors.indigo),
      CategoryData(
          name: 'Phone', icon: Icons.phone_android, color: Colors.lime),
      CategoryData(
          name: 'Internet', icon: Icons.wifi, color: Colors.deepPurple),
      CategoryData(
          name: 'Insurance', icon: Icons.policy, color: Colors.lightGreen),
      CategoryData(
          name: 'Travel', icon: Icons.flight, color: Colors.deepOrange),
      CategoryData(
          name: 'Savings', icon: Icons.savings, color: Colors.lightBlue),
      CategoryData(
          name: 'Investments',
          icon: Icons.trending_up,
          color: Colors.green.shade800),
      CategoryData(
          name: 'Gifts', icon: Icons.card_giftcard, color: Colors.pinkAccent),
      CategoryData(
          name: 'Charity',
          icon: Icons.volunteer_activism,
          color: Colors.blueGrey),
      CategoryData(
          name: 'Personal Care', icon: Icons.spa, color: Colors.green.shade500),
      CategoryData(
          name: 'Medical', icon: Icons.local_hospital, color: Colors.redAccent),
      CategoryData(
          name: 'Childcare',
          icon: Icons.child_care,
          color: Colors.purpleAccent),
      CategoryData(
          name: 'Pet Care',
          icon: Icons.pets,
          color: Colors.tealAccent.shade700),
      CategoryData(
          name: 'Debt Payments',
          icon: Icons.credit_card,
          color: Colors.amberAccent),
      CategoryData(
          name: 'Alcohol',
          icon: FontAwesomeIcons.wineGlass,
          color: Colors.orangeAccent),
      CategoryData(
          name: 'Coffee', icon: FontAwesomeIcons.codeFork, color: Colors.brown),
      CategoryData(
          name: 'Fast Food',
          icon: FontAwesomeIcons.burger,
          color: Colors.limeAccent),
      CategoryData(
          name: 'Laundry',
          icon: FontAwesomeIcons.soap,
          color: Colors.blueAccent),
      CategoryData(
          name: 'Parking',
          icon: FontAwesomeIcons.squareParking,
          color: Colors.cyanAccent),
      CategoryData(
          name: 'Miscellaneous', icon: Icons.more_horiz, color: Colors.grey),
      // Add more categories as needed
    ];

    // Convert categories to a list of maps
    List<Map<String, dynamic>> categoryMaps =
        categories.map((category) => category.toMap()).toList();

// Now you can insert these maps into your database
//     DatabaseHelper dbHelper = DatabaseHelper();
    categoryMaps.forEach((categoryMap) async {
      await db.insert('categories', categoryMap);
    });
  }

  // Insert a category into the database
  Future<void> insertCategory2(Map<String, dynamic> category) async {
    Database db = await database;
    await db.insert('categories', category);
  }

  // Retrieve all categories from the database
  Future<List<CategoryData>> getCategories2() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return CategoryData.fromMap(maps[i]);
    });
  }

  Future<void> insertTransaction2(AddTransactionsData transaction) async {
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

  Future<List<AddTransactionsData>> getTransactions2() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('transactions');

    return List.generate(maps.length, (i) {
      return AddTransactionsData.fromMap(maps[i]);
    });
  }

  Future<void> updateExpensesSameCategoryTransactionBySameDate(AddTransactionsData transaction) async {
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

  Future<void> updateTransaction(AddTransactionsData transaction) async {
    final db = await database;
    print(
        'Updating transaction in DB****************************************: ${transaction.id} with new amount: ${transaction.expensesPrice}');
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

  //getting data by date
  Future<List<AddTransactionsData>> getAllTransactionsSortedByDate() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'transactions',
      orderBy: 'date DESC', // or 'date DESC' for descending order or 'date ASC' for ascending order
    );
    return results.map((e) => AddTransactionsData.fromMap(e)).toList();
  }

  // get data by date and category ************************

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
