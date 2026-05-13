import 'package:flutter/material.dart';
import 'package:gestion_gastos/models/transaction.dart';
import 'package:gestion_gastos/services/database.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  final DatabaseService _databaService = DatabaseService();
  
  List<Transaction> get transactions => _transactions;

  Future<void> loadTransactions() async {
    _transactions = await _databaService.getTransactions();
    notifyListeners();
  }
  
  void addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
    await _databaService.insertTransaction(transaction);
    notifyListeners();
  }

  void deleteTransaction(String id) async{
    _transactions.removeWhere((transaction) => transaction.id == id);
    await _databaService.deleteTransaction(id);
    notifyListeners();
  }

  void updateTransaction(Transaction updatedTransaction) async {
    int index = _transactions.indexWhere((transaction) => transaction.id == updatedTransaction.id);
    _transactions[index] = updatedTransaction;
    await _databaService.updateTransaction(updatedTransaction);
    notifyListeners();
  }

}