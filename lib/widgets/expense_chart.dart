import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gestion_gastos/models/expense_data.dart';

class ExpenseChart extends StatelessWidget {
  final List<ExpenseData> expenses;

  const ExpenseChart({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final categories = expenses.map((e) => e.category).toList();
    final values = expenses.map((e) => e.amount).toList();

    return SizedBox(
      height: 250, // tamaño más pequeño
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,

            maxY: values.isEmpty
                ? 100
                : values.reduce((a, b) => a > b ? a : b) + 20,

            borderData: FlBorderData(show: false),

            gridData: FlGridData(show: true),

            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                ),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,

                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= categories.length) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        categories[value.toInt()],
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ),

            barGroups: List.generate(
              expenses.length,
              (index) {
                return BarChartGroupData(
                  x: index,

                  barRods: [
                    BarChartRodData(
                      toY: values[index],
                      width: 16, // barras más pequeñas
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
