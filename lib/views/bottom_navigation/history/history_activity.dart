import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/widgets/bottom_nav/custom_bottom_nav_bar.dart';

class HistoryActivity extends StatelessWidget {
  const HistoryActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('History'),
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: 2),
      ),
    );
  }
}