import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker/core/res/app_colors.dart';
import 'package:personal_expense_tracker/core/widgets/bottom_nav/custom_bottom_nav_bar.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/insights/controller/insights_controller.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/insights/widgets/insights_amount_card.dart';

class InsightsActivity extends GetView<InsightsController> {
  const InsightsActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Insights & Analytics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: InsightsAmountCard(
                        cardTitle: 'This Month',
                        amount: 0
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: InsightsAmountCard(
                        cardTitle: 'Daily Average',
                        amount: 0
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: 3),
      ),
    );
  }
}