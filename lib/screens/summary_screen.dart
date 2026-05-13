import 'package:flutter/material.dart';
import 'package:gestion_gastos/models/expense_data.dart';
import 'package:gestion_gastos/models/transaction.dart';
import 'package:gestion_gastos/providers/transaction_provider.dart';
import 'package:gestion_gastos/screens/transaction_form_screen.dart';
import 'package:gestion_gastos/screens/transaction_historial_screen.dart';
import 'package:gestion_gastos/widgets/expense_chart.dart';
import 'package:provider/provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    final totalIncome = transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

     final totalExpense = transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);   

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Gastos del mes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionHistorialScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumen Gastos del mes',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: Icon(Icons.arrow_upward_outlined, color: Colors.green),
                  title: Text('Ingresos'),
                  subtitle: Text('\$${totalIncome.toStringAsFixed(2)}'),
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: Icon(Icons.arrow_downward_outlined, color: Colors.red),
                  title: Text('Gastos'),
                  subtitle: Text('\$${totalExpense.toStringAsFixed(2)}'),
                ),
              ),
              SizedBox(height: 20),
              ExpenseChart(),
        
              SizedBox(height: 20),
        
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionFormScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white,),
                  label: const Text('añadir transacion',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
