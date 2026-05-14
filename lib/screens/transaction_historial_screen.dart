import 'package:flutter/material.dart';
import 'package:gestion_gastos/models/transaction.dart';
import 'package:gestion_gastos/providers/transaction_provider.dart';
import 'package:gestion_gastos/screens/transaction_form_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionHistorialScreen extends StatelessWidget {
  const TransactionHistorialScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    


    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text('No hay transacciones registradas.'),
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      transaction.type == TransactionType.income ? Icons.arrow_upward_outlined : Icons.arrow_downward_outlined,
                      color: transaction.type == TransactionType.income ? Colors.green : Colors.red,
                    ),
                    title: Text(transaction.category),
                    subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
                    trailing: Text('\$${transaction.amount.toStringAsFixed(2)}', style: TextStyle(
                      color: transaction.type == TransactionType.income ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:  (context) => TransactionFormScreen(transaction: transaction)));
                    },
                    onLongPress: (){
                      transactionProvider.deleteTransaction(transaction.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transacción eliminada'))
                      );
                    },
                  ),

                );
              },
            ),
    );
  }
}