import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/widgets/bottom_nav/custom_bottom_nav_bar.dart';

class InsightsActivity extends StatelessWidget {
  const InsightsActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Insights'),
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: 3),
      ),
    );
  }
}