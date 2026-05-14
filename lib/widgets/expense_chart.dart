import 'package:flutter/material.dart';
import 'package:gestion_gastos/models/transaction.dart';
import 'package:gestion_gastos/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    final expenses = transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .toList();

    final Map<String, double> categoryTotals = {};

    for (var transaction in expenses) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    final categories = categoryTotals.keys.toList();

    // ✅ CORRECCIÓN 1: Validación temprana si no hay gastos
    if (categories.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(
          child: Text(
            'No hay gastos registrados',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final maxAmount = categoryTotals.values.reduce((a, b) => a > b ? a : b);

    // ✅ CORRECCIÓN 2: ValueKey para forzar rebuild cuando cambian los datos
    return SizedBox(
      key: ValueKey(categoryTotals.toString()),
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,

            // ✅ CORRECCIÓN 3: maxY con 20% de margen en lugar de solo +10
            maxY: maxAmount * 1.2,

            barGroups: List.generate(categories.length, (index) {
              final category = categories[index];
              final amount = categoryTotals[category]!;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: amount,
                    width: 20,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }),

            // ✅ CORRECCIÓN 4: titlesData completo — se ocultan explícitamente
            // los ejes que no se usan para evitar rendering incorrecto
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= categories.length) return const SizedBox();

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        categories[index],
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ✅ CORRECCIÓN 5: Touch deshabilitado para evitar conflictos visuales
            barTouchData: BarTouchData(enabled: false),
          ),
        ),
      ),
    );
  }
}