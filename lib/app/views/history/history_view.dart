import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/categories.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/expense_model.dart';
import '../../widgets/expense_tile.dart';
import '../home/main_controller.dart';

class HistoryView extends GetView<MainController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCtrl = TextEditingController();
    final search = ''.obs;
    final selectedCat = 'All'.obs;
    final sortMode = 'Newest First'.obs;
    final dateRange = Rxn<DateTimeRange>();
    final locationOnly = false.obs;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Expense History',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Obx(() => Text(
              '${controller.expenses.length} transactions · \$${controller.totalAllTime.toStringAsFixed(2)} total',
              style: TextStyle(color: Theme.of(context).hintColor),
            )),
            const SizedBox(height: 16),
            TextField(
              controller: searchCtrl,
              onChanged: (v) => search.value = v.toLowerCase(),
              decoration: const InputDecoration(
                hintText: 'Search expenses...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chip('All', selectedCat),
                  ...categories.map((c) => _chip(c.name, selectedCat)),
                ],
              )),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Date range filter
                Obx(() => InkWell(
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange: dateRange.value,
                    );
                    if (picked != null) dateRange.value = picked;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: dateRange.value != null
                          ? AppColors.primary.withOpacity(0.1)
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: [
                      Icon(Icons.date_range,
                          size: 16,
                          color: dateRange.value != null
                              ? AppColors.primary
                              : Theme.of(context).hintColor),
                      const SizedBox(width: 4),
                      Text(
                        dateRange.value == null
                            ? 'Date'
                            : '${DateFormat('MMM d').format(dateRange.value!.start)} - ${DateFormat('MMM d').format(dateRange.value!.end)}',
                        style: TextStyle(
                            fontSize: 12,
                            color: dateRange.value != null
                                ? AppColors.primary
                                : null),
                      ),
                      if (dateRange.value != null) ...[
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => dateRange.value = null,
                          child: const Icon(Icons.close,
                              size: 14, color: AppColors.primary),
                        ),
                      ],
                    ]),
                  ),
                )),
                const SizedBox(width: 8),
                // Location filter
                Obx(() => InkWell(
                  onTap: () => locationOnly.toggle(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: locationOnly.value
                          ? AppColors.primary.withOpacity(0.1)
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(children: [
                      Icon(Icons.location_on,
                          size: 16,
                          color: locationOnly.value
                              ? AppColors.primary
                              : Theme.of(context).hintColor),
                      const SizedBox(width: 4),
                      Text('Tagged only',
                          style: TextStyle(
                              fontSize: 12,
                              color: locationOnly.value
                                  ? AppColors.primary
                                  : null)),
                    ]),
                  ),
                )),
                const Spacer(),
                // Sort
                Obx(() => DropdownButton<String>(
                  value: sortMode.value,
                  isDense: true,
                  items: const [
                    DropdownMenuItem(value: 'Newest First', child: Text('Newest First')),
                    DropdownMenuItem(value: 'Oldest First', child: Text('Oldest First')),
                    DropdownMenuItem(value: 'Highest', child: Text('Highest')),
                    DropdownMenuItem(value: 'Lowest', child: Text('Lowest')),
                  ],
                  onChanged: (v) => sortMode.value = v ?? 'Newest First',
                )),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                var list = controller.expenses.toList();

                if (search.value.isNotEmpty) {
                  list = list
                      .where((e) =>
                  e.title.toLowerCase().contains(search.value) ||
                      e.category.toLowerCase().contains(search.value) ||
                      (e.location?.toLowerCase().contains(search.value) ?? false))
                      .toList();
                }
                if (selectedCat.value != 'All') {
                  list = list.where((e) => e.category == selectedCat.value).toList();
                }
                if (dateRange.value != null) {
                  final start = dateRange.value!.start;
                  final end = dateRange.value!.end.add(const Duration(days: 1));
                  list = list
                      .where((e) => e.date.isAfter(start) && e.date.isBefore(end))
                      .toList();
                }
                if (locationOnly.value) {
                  list = list.where((e) => e.location != null).toList();
                }

                switch (sortMode.value) {
                  case 'Oldest First':
                    list.sort((a, b) => a.date.compareTo(b.date));
                    break;
                  case 'Highest':
                    list.sort((a, b) => b.amount.compareTo(a.amount));
                    break;
                  case 'Lowest':
                    list.sort((a, b) => a.amount.compareTo(b.amount));
                    break;
                  default:
                    list.sort((a, b) => b.date.compareTo(a.date));
                }

                if (list.isEmpty) {
                  return Center(
                    child: Text('No expenses found',
                        style: TextStyle(color: Theme.of(context).hintColor)),
                  );
                }
                return _GroupedList(items: list);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, RxString selected) {
    final isSel = selected.value == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => selected.value = label,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? AppColors.primary : Theme.of(Get.context!).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label,
              style: TextStyle(
                  color: isSel ? Colors.white : null,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}

class _GroupedList extends StatelessWidget {
  final List<ExpenseModel> items;
  const _GroupedList({required this.items});

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<ExpenseModel>>{};
    for (final e in items) {
      final key = DateFormat('EEEE, MMM d').format(e.date);
      groups.putIfAbsent(key, () => []).add(e);
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: groups.entries.expand((entry) {
        final dayTotal = entry.value.fold<double>(0, (a, b) => a + b.amount);
        return [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: TextStyle(color: Theme.of(context).hintColor)),
                Text('\$${dayTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ...entry.value.map((e) => ExpenseTile(expense: e)),
        ];
      }).toList(),
    );
  }
}