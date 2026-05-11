import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/categories.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/expense_tile.dart';
import 'main_controller.dart';

class HomeView extends GetView<MainController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            const SizedBox(height: 20),
            _SummaryCard(),
            const SizedBox(height: 24),
            const Text('Quick Add',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _QuickAddGrid(),
            const SizedBox(height: 24),
            _RecentHeader(),
            const SizedBox(height: 12),
            _RecentList(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();
    return Row(
      children: [
        Expanded(
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(_greeting(),
                    style: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 14)),
                const SizedBox(width: 4),
                const Text('👋'),
              ]),
              const SizedBox(height: 4),
              Text(c.user.value?.username ?? '...',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          )),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

class _SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();
    return Obx(() {
      final pct = c.monthChangePercent;
      final isDown = pct < 0;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              Icon(Icons.calendar_today_outlined, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text('This Month', style: TextStyle(color: Colors.white, fontSize: 14)),
            ]),
            const SizedBox(height: 8),
            Text('\$${c.totalThisMonth.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Icon(isDown ? Icons.trending_down : Icons.trending_up,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text('${pct.abs().toStringAsFixed(1)}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                ]),
              ),
              const SizedBox(width: 8),
              const Text('vs last month',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
            const SizedBox(height: 16),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 16),
            Row(children: [
              _stat('Transactions', '${c.monthCount}'),
              _stat('Avg / Day', '\$${c.monthAvgPerDay.toStringAsFixed(0)}'),
              _stat('Highest', '\$${c.monthHighest.toStringAsFixed(0)}'),
            ]),
          ],
        ),
      );
    });
  }

  Widget _stat(String label, String value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

class _QuickAddGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (_, i) {
        final cat = categories[i];
        return InkWell(
          onTap: () => Get.toNamed(Routes.addExpense, arguments: cat.name),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cat.bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(cat.icon, color: cat.iconColor),
              ),
              const SizedBox(height: 6),
              Text(cat.name,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      },
    );
  }
}

class _RecentHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Recent Expenses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => c.changeTab(1),
          child: Row(children: const [
            Text('See All', style: TextStyle(color: AppColors.primary)),
            Icon(Icons.chevron_right, color: AppColors.primary, size: 18),
          ]),
        ),
      ],
    );
  }
}

class _RecentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();
    return Obx(() {
      final items = c.expenses.take(3).toList();
      if (items.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Text('No expenses yet. Tap + to add one!',
                style: TextStyle(color: Theme.of(context).hintColor)),
          ),
        );
      }
      return Column(
        children: items.map((e) => ExpenseTile(expense: e)).toList(),
      );
    });
  }
}