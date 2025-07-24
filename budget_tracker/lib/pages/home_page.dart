import 'package:budget_tracker/controllers/dashboard_provider.dart';
import 'package:budget_tracker/models/expense_model.dart';
import 'package:budget_tracker/pages/expense_chart_page.dart';
import 'package:budget_tracker/pages/expense_form_page.dart';
import 'package:budget_tracker/values/constants.dart';
import 'package:budget_tracker/values/enums.dart';
import 'package:budget_tracker/widgets/overlay_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchExpenses(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final effectiveExpenses = provider.effectiveExpenses(
          _tabController.index,
        );
        return OverlayLoader(
          showLoader: provider.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Expense Tracker'),
              actions: [
                if (effectiveExpenses.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: IconButton(
                      onPressed: () =>
                          provider.exportExpensesToCsv(effectiveExpenses),
                      icon: Icon(
                        Icons.import_export,
                        size: 30,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
                if (effectiveExpenses.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExpenseChartPage(expenses: effectiveExpenses),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.bar_chart,
                        size: 30,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            body: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  onTap: (_) => setState(() {}),
                  dividerHeight: 0,
                  labelStyle: TextStyle(fontSize: 17),
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.all(10),
                  tabs: [Text('Daily'), Text('Weekly'), Text('Monthly')],
                ),
                Expanded(
                  child: effectiveExpenses.isEmpty
                      ? _buildEmptyData()
                      : _buildExpensesView(effectiveExpenses),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpenseFormPage()),
                  );
                },
                child: Icon(CupertinoIcons.add, size: 35, color: Colors.black),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpensesView(List<ExpenseModel> expenses) => ListView.separated(
    padding: EdgeInsets.all(20).copyWith(bottom: 120),
    itemCount: expenses.length,
    itemBuilder: (context, index) => ExpenseCard(expense: expenses[index]),
    separatorBuilder: (context, index) => SizedBox(height: 15),
  );

  Widget _buildEmptyData() => Center(
    child: Padding(
      padding: EdgeInsets.only(bottom: AppBar().preferredSize.height * 2.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/empty_expenses.png',
            width: MediaQuery.sizeOf(context).width * 0.6,
            height: MediaQuery.sizeOf(context).width * 0.6,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 15),
          Text(
            'No Expenses...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Constants.primaryColor,
            ),
          ),
        ],
      ),
    ),
  );
}

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category icon
          Padding(
            padding: EdgeInsets.only(top: 15, left: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.2),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                ExpenseCategory.entertainment.icon,
                size: 35,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category name and creation date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          expense.category.displayName.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        expense.date,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => context
                          .read<DashboardProvider>()
                          .deleteExpense(context, expense.id),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CupertinoColors.destructiveRed,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.delete,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // Amount
                Text(
                  '\$${expense.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                // Description
                Padding(
                  padding: EdgeInsets.only(bottom: 15, right: 15),
                  child: Text(
                    expense.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
