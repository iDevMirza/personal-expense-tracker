import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../history/history_view.dart';
import '../insights/insights_view.dart';
import '../profile/profile_view.dart';
import 'home_view.dart';
import 'main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeView(),
      HistoryView(),
      SizedBox.shrink(),
      InsightsView(),
      ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedTab.value,
        children: pages,
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => Get.toNamed(Routes.addExpense),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(c, 0, Icons.home_outlined, 'Home'),
          _navItem(c, 1, Icons.access_time, 'History'),
          const SizedBox(width: 48),
          _navItem(c, 3, Icons.pie_chart_outline, 'Insights'),
          _navItem(c, 4, Icons.person_outline, 'Profile'),
        ],
      )),
    );
  }

  Widget _navItem(MainController c, int idx, IconData icon, String label) {
    final selected = c.selectedTab.value == idx;
    final color = selected ? AppColors.primary : Theme.of(Get.context!).hintColor;
    return InkWell(
      onTap: () => c.changeTab(idx),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: selected
            ? BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(12))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}