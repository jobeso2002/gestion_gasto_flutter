import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart' as TransactionModel;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;

    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'transanctions.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions(
        id TEXT PRIMARY KEY,
        category TEXT,
        amount REAL,
        type TEXT,
        date TEXT
      )
    ''');
  }


  //funcion para insertar una transaccion
  Future<void> insertTransaction(TransactionModel.Transaction transaction) async {
    final db = await database;
    await db.insert('transactions', 
    transaction.toMap(), 
    conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //funcion para obtener todas las transacciones
  Future<List<TransactionModel.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    return List.generate(maps.length, (i) {
      return TransactionModel.Transaction(
        id: maps[i]['id'],
        category: maps[i]['category'],
        amount: maps[i]['amount'],
        type: maps[i]['type'] == 'income' ? TransactionModel.TransactionType.income : TransactionModel.TransactionType.expense,
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  //funcion eliminar una transaccion
  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }




}