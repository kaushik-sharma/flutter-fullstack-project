import 'package:flutter/material.dart';

enum AuthMode { signIn, signUp }

enum ExpenseCategory {
  food(displayName: "Food", icon: Icons.fastfood_rounded),
  groceries(displayName: "Groceries", icon: Icons.local_grocery_store_rounded),
  entertainment(
    displayName: "Entertainment",
    icon: Icons.movie_creation_rounded,
  ),
  travel(displayName: "Travel", icon: Icons.travel_explore),
  shopping(displayName: "Shopping", icon: Icons.shopping_bag_rounded),
  misc(displayName: "Misc", icon: Icons.miscellaneous_services_rounded);

  final String displayName;
  final IconData icon;

  const ExpenseCategory({required this.displayName, required this.icon});
}
