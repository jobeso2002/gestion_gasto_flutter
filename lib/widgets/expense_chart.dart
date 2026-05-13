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
          (categoryTotals[transaction.category] ?? 0) +
              transaction.amount;
    }

    final categories = categoryTotals.keys.toList();

    // VALIDACIÓN IMPORTANTE
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

    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: categoryTotals.values.reduce(
                  (a, b) => a > b ? a : b,
                ) +
                20,
            barGroups: List.generate(
              categories.length,
              (index) {
                final category = categories[index];
                final amount = categoryTotals[category]!;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: amount,
                      width: 20,
                    ),
                  ],
                );
              },
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= categories.length) {
                      return const SizedBox();
                    }

                    return Text(
                      categories[value.toInt()],
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}