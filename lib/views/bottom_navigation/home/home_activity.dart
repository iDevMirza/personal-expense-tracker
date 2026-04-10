import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker/core/res/app_assets.dart';
import 'package:personal_expense_tracker/core/res/app_colors.dart';
import 'package:personal_expense_tracker/core/widgets/bottom_nav/custom_bottom_nav_bar.dart';
import 'package:personal_expense_tracker/core/widgets/bottom_sheet/custom_modal_bottom_sheet.dart';
import 'package:personal_expense_tracker/routes/app_routes.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/home/controller/home_controller.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/home/widgets/home_sheet_content.dart';

class HomeActivity extends GetView<HomeController> {
  const HomeActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Good Afternoon',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 2),

              Text(
                'Mirza Mahmud Hossan',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.6)
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: (){
                  CustomModalBottomSheet.show(
                     context,
                     bottomSheetContent: HomeSheetContent(
                       onTheme: (value){},
                       onLogout: (){},
                     )
                  );
                },
                icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 24
                )
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Card(
                elevation: 0,
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(12),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'This Month\'s Spending',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 8),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                          children: [
                            TextSpan(
                              text: '£ '
                            ),
                            TextSpan(
                              text: '0.00'
                            )
                          ]
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: .start,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.white.withValues(alpha: 0.4),
                            size: 16,
                          ),
                          const SizedBox(width: 8),

                          Text(
                            'April 2026',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () {
                  Get.offAllNamed(AppRoutes.addActivity);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsetsDirectional.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.2)
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsetsDirectional.all(8),
                              alignment: .center,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(12)
                              ),
                              child: Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: 20
                              ),
                            ),
                            const SizedBox(width: 12),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add Expense',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                  ),
                                ),
                                const SizedBox(height: 2),

                                Text(
                                  'Record a new transaction',
                                  style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.4),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black.withValues(alpha: 0.4),
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Recent Expenses',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 12),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 12),
                alignment: .center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.2))
                ),
                child: Column(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
                  children: [
                    SvgPicture.asset(
                        AppAssets.arrowTrendDownIcon,
                      height: 24, width: 24,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.6),
                          BlendMode.srcIn
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: .center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.4),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5
                        ),
                        children: [
                          TextSpan(
                            text: 'No expenses yet\n',
                          ),
                          TextSpan(
                            text: 'Tap "Add" to record your first expense'
                          )
                        ]
                      ),
                    )
                  ],
                )
              )
              // ListView.separated(
              //   shrinkWrap: true,
              //   padding: EdgeInsets.zero,
              //   scrollDirection: Axis.vertical,
              //   itemBuilder: (context, index) => Container(
              //     width: double.infinity,
              //     height: 48,
              //     color: Colors.black,
              //   ),
              //   separatorBuilder: (context, index) => const SizedBox(height: 12),
              //   itemCount: 20,
              //   physics: NeverScrollableScrollPhysics(),
              // )
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: 0),
      ),
    );
  }
}