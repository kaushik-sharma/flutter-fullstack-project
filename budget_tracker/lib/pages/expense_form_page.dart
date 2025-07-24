import 'package:budget_tracker/controllers/dashboard_provider.dart';
import 'package:budget_tracker/controllers/expense_form_provider.dart';
import 'package:budget_tracker/values/enums.dart';
import 'package:budget_tracker/widgets/custom_button.dart';
import 'package:budget_tracker/widgets/custom_dropdown.dart';
import 'package:budget_tracker/widgets/custom_text_field.dart';
import 'package:budget_tracker/widgets/overlay_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseFormPage extends StatefulWidget {
  const ExpenseFormPage({super.key});

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExpenseFormProvider>(
      create: (context) => ExpenseFormProvider(),
      builder: (context, child) => Consumer<ExpenseFormProvider>(
        builder: (context, provider, child) => OverlayLoader(
          showLoader: provider.isLoading,
          child: Scaffold(
            appBar: AppBar(title: Text('New Expense')),
            body: Form(
              key: provider.formKey,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  CustomDropdown<ExpenseCategory>(
                    value: provider.selectedCategory,
                    values: ExpenseCategory.values,
                    labels: ExpenseCategory.values
                        .map((e) => e.displayName)
                        .toList(),
                    hint: 'Category',
                    validator: (value) {
                      if (value == null) {
                        return 'Required';
                      }
                      return null;
                    },
                    onChanged: (value) => provider.selectedCategory = value,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: provider.amountController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      final parsedValue = int.tryParse(value);
                      if (parsedValue == null || parsedValue <= 0) {
                        return 'Must be more than 0';
                      }
                      return null;
                    },
                    label: 'Amount',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: provider.descriptionController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    label: 'Description',
                    maxLines: 4,
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      final now = DateTime.now();
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(1901),
                        lastDate: now,
                      );
                      if (pickedDate == null) return;

                      provider.dateController.text = pickedDate
                          .toIso8601String()
                          .split('T')[0];
                    },
                    child: CustomTextField(
                      controller: provider.dateController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        final date = DateTime.tryParse(value);
                        if (date == null) {
                          return 'Invalid date format';
                        }
                        return null;
                      },
                      label: 'Date',
                      suffixIcon: Icons.date_range,
                      isEnabled: false,
                    ),
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    onPressed: () async {
                      final isSuccess = await provider.submitForm(context);
                      if (!isSuccess) return;
                      Navigator.pop(context);
                      context.read<DashboardProvider>().fetchExpenses(context);
                    },
                    text: 'Add Expense',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
