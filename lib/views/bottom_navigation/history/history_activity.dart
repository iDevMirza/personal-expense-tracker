import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/res/app_colors.dart';
import 'package:personal_expense_tracker/core/widgets/bottom_nav/custom_bottom_nav_bar.dart';

class HistoryActivity extends StatelessWidget {
  const HistoryActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Expense History',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  contentPadding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 12),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'All Categories',
                          contentPadding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'By Date',
                          contentPadding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => Container(
                      width: double.infinity,
                      height: 48,
                      color: AppColors.primaryColor,
                    ),
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemCount: 20
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: 2),
      ),
    );
  }
}