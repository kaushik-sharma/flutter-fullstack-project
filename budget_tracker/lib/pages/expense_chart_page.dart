import 'package:budget_tracker/models/expense_model.dart';
import 'package:budget_tracker/values/enums.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseChartPage extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const ExpenseChartPage({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Expenses by Category',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ExpensesPieChart(expenses: expenses),
            ),
          ),
          SizedBox(height: 60),
          Text(
            'Spending Over Time',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ExpensesLineChart(expenses: expenses),
            ),
          ),
          SizedBox(height: 40),
          Text(
            'Category Bar Chart',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ExpensesBarChart(expenses: expenses),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pie Chart
class ExpensesPieChart extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const ExpensesPieChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final dataMap = _aggregateByCategory(expenses);
    final colors = _categoryColors;
    final total = dataMap.values.fold<double>(0, (p, e) => p + e);

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 30,
        borderData: FlBorderData(show: false),
        sections: dataMap.entries.map((entry) {
          final category = entry.key;
          final amount = entry.value;
          final percent = (amount / total) * 100;
          return PieChartSectionData(
            color: colors[category]!,
            value: amount,
            title: '${percent.toStringAsFixed(0)}%',
            radius: MediaQuery.of(context).size.width * 0.25,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          );
        }).toList(),
      ),
    );
  }

  Map<ExpenseCategory, double> _aggregateByCategory(List<ExpenseModel> list) {
    final Map<ExpenseCategory, double> map = {};
    for (var e in list) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  static final Map<ExpenseCategory, Color> _categoryColors = {
    ExpenseCategory.food: Colors.red,
    ExpenseCategory.groceries: Colors.blue,
    ExpenseCategory.entertainment: Colors.green,
    ExpenseCategory.travel: Colors.orange,
    ExpenseCategory.shopping: Colors.purple,
    ExpenseCategory.misc: Colors.grey,
  };
}

/// Line Chart: Spending over days
class ExpensesLineChart extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const ExpensesLineChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, double> dailySum = {};
    for (var e in expenses) {
      final date = DateTime(
        e.parsedDate.year,
        e.parsedDate.month,
        e.parsedDate.day,
      );
      dailySum[date] = (dailySum[date] ?? 0) + e.amount;
    }
    final sortedDates = dailySum.keys.toList()..sort();

    return LineChart(
      LineChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
        backgroundColor: Colors.transparent,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, interval: 1),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < sortedDates.length; i++)
                FlSpot(i.toDouble(), dailySum[sortedDates[i]]!),
            ],
            isCurved: true,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

/// Bar Chart: Amount per category
class ExpensesBarChart extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const ExpensesBarChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final data = _aggregateByCategory(expenses);
    final colors = ExpensesPieChart._categoryColors;
    final categories = data.keys.toList();

    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= categories.length) return Text('');
                return Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    categories[idx].name.substring(0, 1).toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        barGroups: [
          for (int i = 0; i < categories.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[categories[i]]!,
                  color: colors[categories[i]]!,
                  width: 16,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Map<ExpenseCategory, double> _aggregateByCategory(List<ExpenseModel> list) {
    final map = <ExpenseCategory, double>{};
    for (var e in list) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }
}
