import 'package:budget_tracker/models/expense_model.dart';
import 'package:budget_tracker/values/enums.dart';
import 'package:flutter/material.dart';

import '../services/dio_service.dart';

class ExpenseFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  ExpenseCategory? _selectedCategory;
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  ExpenseCategory? get selectedCategory => _selectedCategory;

  set selectedCategory(ExpenseCategory? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  Future<bool> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final a = await DioService.instance.dio.post(
        '/v1/expenses/',
        // Temporary sending fields directly. Later improve with Freezed models.
        data: {
          "category": _selectedCategory!.name.toUpperCase(),
          "amount": double.parse(amountController.text.trim()),
          "description": descriptionController.text.trim(),
          "date": dateController.text.trim(),
        },
      );
      print(a.data);
      return true;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong.')));
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
