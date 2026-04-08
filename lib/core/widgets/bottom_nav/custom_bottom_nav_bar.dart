import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:personal_expense_tracker/core/res/app_assets.dart';
import 'package:personal_expense_tracker/core/res/app_colors.dart';
import 'package:personal_expense_tracker/routes/app_routes.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedMenu;

  const CustomBottomNavBar({
    super.key,
    required this.selectedMenu,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int bottomNavIndex = 0;

  final List<String> menuTitle = ['Home', 'Add', 'History', 'Insights'];

  final List<String> inactiveMenuIcon = [
    AppAssets.homeInActive,
    AppAssets.addInActive,
    AppAssets.historyInActive,
    AppAssets.insightsInActive,
  ];

  final List<String> activeMenuIcon = [
    AppAssets.homeActive,
    AppAssets.addActive,
    AppAssets.historyInActive,
    AppAssets.insightsActive,
  ];

  @override
  void initState() {
    super.initState();
    bottomNavIndex = widget.selectedMenu;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), offset: const Offset(2, 2), blurRadius: 10, spreadRadius: 2)
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            menuTitle.length,
            (index) => IconButton(
              onPressed: () {
                setState(() {
                  bottomNavIndex = index;
                });
                navigateTo(index);
              },
              icon: bottomNavMenu(itemIndex: index),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomNavMenu({required int itemIndex}) {
    final bool isSelected = itemIndex == bottomNavIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          isSelected
              ? activeMenuIcon[itemIndex]
              : inactiveMenuIcon[itemIndex],
          height: 24,
          width: 24,
          colorFilter: isSelected
              ? const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          menuTitle[itemIndex],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppColors.primaryColor
                : Colors.black.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  void navigateTo(int index) {
    switch (index) {
      case 0:
        Get.offNamed(AppRoutes.homeActivity);
        break;
      case 1:
        Get.offNamed(AppRoutes.addActivity);
        break;
      case 2:
        Get.offNamed(AppRoutes.historyActivity);
        break;
      case 3:
        Get.offNamed(AppRoutes.insightsActivity);
        break;
    }
  }
}