import 'package:flutter/material.dart';
import 'package:gestion_gastos/models/expense_data.dart';
import 'package:gestion_gastos/screens/transaction_form_screen.dart';
import 'package:gestion_gastos/widgets/expense_chart.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ExpenseData> expenseData = [
      ExpenseData('Comida', 150.0),
      ExpenseData('Transporte', 50.0),
      ExpenseData('Entretenimiento', 100.0),
      ExpenseData('Otros', 30.0),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Gastos del mes'),
        centerTitle: true,
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
                  subtitle: Text('\$0.0'),
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: Icon(Icons.arrow_downward_outlined, color: Colors.red),
                  title: Text('Gastos'),
                  subtitle: Text('\$0.0'),
                ),
              ),
              SizedBox(height: 20),
              ExpenseChart(expenses: expenseData),
        
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
                  icon: const Icon(Icons.add),
                  label: const Text('añadir transacion'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
