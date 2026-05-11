import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/categories.dart';
import '../../core/theme/app_colors.dart';
import '../home/main_controller.dart';

class InsightsView extends GetView<MainController> {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Insights',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text('Understand your spending patterns',
                style: TextStyle(color: Theme.of(context).hintColor)),
            const SizedBox(height: 20),
            _Last7Days(),
            const SizedBox(height: 16),
            _ByCategory(),
          ],
        ),
      ),
    );
  }
}

class _Last7Days extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();
    return Obx(() {
      final now = DateTime.now();
      final start =
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
      final daily = List<double>.filled(7, 0);
      for (final e in c.expenses) {
        if (e.date.isAfter(start.subtract(const Duration(seconds: 1)))) {
          final diff = DateTime(e.date.year, e.date.month, e.date.day)
              .difference(start)
              .inDays;
          if (diff >= 0 && diff < 7) daily[diff] += e.amount;
        }
      }
      final total = daily.fold<double>(0, (a, b) => a + b);
      final maxV = daily.fold<double>(0, (a, b) => a > b ? a : b);
      const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Last 7 Days',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Total: \$${total.toStringAsFixed(2)}',
                style: TextStyle(color: Theme.of(context).hintColor)),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxV == 0 ? 100 : maxV * 1.2,
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(labels[v.toInt()],
                            style: TextStyle(
                                fontSize: 11, color: Theme.of(context).hintColor)),
                      ),
                    ),
                  ),
                ),
                barGroups: List.generate(7, (i) {
                  return BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: daily[i],
                      color: AppColors.primary,
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ]);
                }),
              )),
            ),
          ],
        ),
      );
    });
  }
}

class _ByCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<MainController>();
    return Obx(() {
      final totals = <String, double>{};
      for (final e in c.expenses) {
        totals[e.category] = (totals[e.category] ?? 0) + e.amount;
      }
      final sorted = totals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final total = totals.values.fold<double>(0, (a, b) => a + b);

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Spending by Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (sorted.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No data yet')),
              )
            else
              Row(children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: PieChart(PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: sorted.map((e) {
                      final cat = getCategoryByName(e.key);
                      return PieChartSectionData(
                        color: cat.iconColor,
                        value: e.value,
                        title: '',
                        radius: 22,
                      );
                    }).toList(),
                  )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: sorted.take(5).map((e) {
                      final cat = getCategoryByName(e.key);
                      final pct = total == 0 ? 0 : (e.value / total * 100);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: cat.iconColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(e.key)),
                          Text('${pct.toStringAsFixed(0)}%',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                      );
                    }).toList(),
                  ),
                ),
              ]),
          ],
        ),
      );
    });
  }
}