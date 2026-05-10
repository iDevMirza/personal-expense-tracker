import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ExpenseCategory {
  final String name;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const ExpenseCategory({
    required this.name,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}

const categories = <ExpenseCategory>[
  ExpenseCategory(name: 'Food', icon: Icons.restaurant, bgColor: AppColors.food, iconColor: AppColors.foodIcon),
  ExpenseCategory(name: 'Transport', icon: Icons.directions_car, bgColor: AppColors.transport, iconColor: AppColors.transportIcon),
  ExpenseCategory(name: 'Shopping', icon: Icons.shopping_bag, bgColor: AppColors.shopping, iconColor: AppColors.shoppingIcon),
  ExpenseCategory(name: 'Entertainment', icon: Icons.movie, bgColor: AppColors.entertainment, iconColor: AppColors.entertainmentIcon),
  ExpenseCategory(name: 'Bills', icon: Icons.receipt_long, bgColor: AppColors.bills, iconColor: AppColors.billsIcon),
  ExpenseCategory(name: 'Health', icon: Icons.favorite, bgColor: AppColors.health, iconColor: AppColors.healthIcon),
  ExpenseCategory(name: 'Education', icon: Icons.school, bgColor: AppColors.education, iconColor: AppColors.educationIcon),
  ExpenseCategory(name: 'Travel', icon: Icons.flight, bgColor: AppColors.travel, iconColor: AppColors.travelIcon),
];

ExpenseCategory getCategoryByName(String name) {
  return categories.firstWhere(
        (c) => c.name == name,
    orElse: () => categories[0],
  );
}