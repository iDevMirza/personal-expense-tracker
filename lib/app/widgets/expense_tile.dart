import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/categories.dart';
import '../core/theme/app_colors.dart';
import '../data/models/expense_model.dart';
import '../views/home/main_controller.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;
  final bool showCategoryLabel;
  const ExpenseTile({super.key, required this.expense, this.showCategoryLabel = true});

  Future<void> _openMap() async {
    if (expense.latitude == null || expense.longitude == null) return;
    final uri = Uri.parse(
        'https://www.openstreetmap.org/?mlat=${expense.latitude}&mlon=${expense.longitude}#map=18/${expense.latitude}/${expense.longitude}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _confirmDelete() async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete expense?'),
        content: Text('Remove "${expense.title}" from your records?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await Get.find<MainController>().deleteExpense(expense.id);
      Get.snackbar('Deleted', 'Expense removed', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cat = getCategoryByName(expense.category);
    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        await _confirmDelete();
        return false; // we delete via the dialog
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete, color: AppColors.error),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cat.bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(cat.icon, color: cat.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(DateFormat('MMM d, h:mm a').format(expense.date),
                          style: TextStyle(
                              fontSize: 12, color: Theme.of(context).hintColor)),
                      if (expense.location != null) ...[
                        const SizedBox(width: 4),
                        const Text('·',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: GestureDetector(
                            onTap: _openMap,
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 12, color: AppColors.primary),
                                Flexible(
                                  child: Text(
                                    expense.location!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12, color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (showCategoryLabel)
                  Text(expense.category,
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).hintColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}