import 'dart:io';

import 'package:budget_tracker/models/expense_model.dart';
import 'package:budget_tracker/services/dio_service.dart';
import 'package:budget_tracker/values/enums.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final _dummyExpenses = <ExpenseModel>[
    ExpenseModel(
      id: 'e1',
      category: ExpenseCategory.food,
      amount: 12.50,
      description: 'Lunch at Cafe',
      date: '2025-07-01',
    ),
    ExpenseModel(
      id: 'e2',
      category: ExpenseCategory.travel,
      amount: 3.20,
      description: 'Bus ticket',
      date: '2025-07-03',
    ),
    ExpenseModel(
      id: 'e3',
      category: ExpenseCategory.groceries,
      amount: 45.00,
      description: 'Supermarket shopping',
      date: '2025-07-05',
    ),
    ExpenseModel(
      id: 'e4',
      category: ExpenseCategory.entertainment,
      amount: 15.00,
      description: 'Movie ticket',
      date: '2025-07-07',
    ),
    ExpenseModel(
      id: 'e5',
      category: ExpenseCategory.travel,
      amount: 120.00,
      description: 'Train to city',
      date: '2025-07-09',
    ),
    ExpenseModel(
      id: 'e6',
      category: ExpenseCategory.shopping,
      amount: 75.99,
      description: 'New shoes',
      date: '2025-07-11',
    ),
    ExpenseModel(
      id: 'e7',
      category: ExpenseCategory.misc,
      amount: 5.00,
      description: 'Coffee',
      date: '2025-07-13',
    ),
    ExpenseModel(
      id: 'e8',
      category: ExpenseCategory.food,
      amount: 8.25,
      description: 'Breakfast sandwich',
      date: '2025-07-15',
    ),
    ExpenseModel(
      id: 'e9',
      category: ExpenseCategory.misc,
      amount: 60.00,
      description: 'Electricity bill',
      date: '2025-07-17',
    ),
    ExpenseModel(
      id: 'e10',
      category: ExpenseCategory.shopping,
      amount: 30.00,
      description: 'Pharmacy purchase',
      date: '2025-07-19',
    ),
    ExpenseModel(
      id: 'e11',
      category: ExpenseCategory.misc,
      amount: 25.00,
      description: 'Taxi ride',
      date: '2025-07-21',
    ),
    ExpenseModel(
      id: 'e12',
      category: ExpenseCategory.groceries,
      amount: 32.10,
      description: 'Veggies & fruits',
      date: '2025-07-23',
    ),
    ExpenseModel(
      id: 'e13',
      category: ExpenseCategory.entertainment,
      amount: 50.00,
      description: 'Concert ticket',
      date: '2025-07-25',
    ),
    ExpenseModel(
      id: 'e14',
      category: ExpenseCategory.travel,
      amount: 200.00,
      description: 'Weekend getaway',
      date: '2025-07-27',
    ),
    ExpenseModel(
      id: 'e15',
      category: ExpenseCategory.shopping,
      amount: 150.75,
      description: 'Clothing haul',
      date: '2025-07-31',
    ),
  ];

  var _expenses = <ExpenseModel>[];

  List<ExpenseModel> get expenses => [..._expenses];

  Future<void> fetchExpenses(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await DioService.instance.dio.get('/v1/expenses/');
      final expensesMaps = response.data['data']['expenses'] as List<dynamic>;
      final expenses = <ExpenseModel>[];
      for (final map in expensesMaps) {
        expenses.add(
          ExpenseModel(
            id: map['id'],
            category: ExpenseCategory.values.byName(
              map['category'].toString().toLowerCase(),
            ),
            amount: double.parse(map['amount']),
            description: map['description'],
            date: map['date'],
          ),
        );
      }
      _expenses = [...expenses, ..._dummyExpenses];
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong.')));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(BuildContext context, String expenseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DioService.instance.dio.delete('/v1/expenses/$expenseId');
      _expenses.removeWhere((element) => element.id == expenseId);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong.')));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  DateTime get _now => DateTime.now();

  DateTime get _startOfDay => DateTime(_now.year, _now.month, _now.day);

  DateTime get _startOfWeek {
    final weekday = _now.weekday;
    return _startOfDay.subtract(Duration(days: weekday - 1));
  }

  DateTime get _startOfMonth => DateTime(_now.year, _now.month, 1);

  List<ExpenseModel> get dailyExpenses => _expenses.where((e) {
    return e.parsedDate.isAfter(_startOfDay) ||
        e.parsedDate.isAtSameMomentAs(_startOfDay);
  }).toList();

  List<ExpenseModel> get weeklyExpenses => _expenses.where((e) {
    return e.parsedDate.isAfter(_startOfWeek) ||
        e.parsedDate.isAtSameMomentAs(_startOfWeek);
  }).toList();

  List<ExpenseModel> get monthlyExpenses => _expenses.where((e) {
    return e.parsedDate.isAfter(_startOfMonth) ||
        e.parsedDate.isAtSameMomentAs(_startOfMonth);
  }).toList();

  List<ExpenseModel> effectiveExpenses(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return dailyExpenses;
      case 1:
        return weeklyExpenses;
      case 2:
        return monthlyExpenses;
      default:
        throw Exception('Invalid tab index.');
    }
  }

  Future<void> exportExpensesToCsv(List<ExpenseModel> expenses) async {
    // 1. Build header row + data rows
    final rows = <List<dynamic>>[
      ['ID', 'Category', 'Amount', 'Description', 'Date'],
      ...expenses.map(
        (e) => [
          e.id,
          e.category.name,
          e.amount.toStringAsFixed(2),
          e.description,
          e.date,
        ],
      ),
    ];

    // 2. Convert to CSV string
    final csvString = const ListToCsvConverter().convert(rows);

    // 3. Write to a file in the app's documents directory
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/expenses_export.csv');
    await file.writeAsString(csvString);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'My Expense Report',
      subject: 'Expenses CSV',
    );
  }
}
