import 'package:budget_tracker/values/enums.dart';

class ExpenseModel {
  final String id;
  final ExpenseCategory category;
  final double amount;
  final String description;
  final String date;

  const ExpenseModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });

  DateTime get parsedDate => DateTime.parse(date);
}
