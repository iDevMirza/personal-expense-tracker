import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/categories.dart';
import '../../core/theme/app_colors.dart';
import 'add_expense_controller.dart';

class AddExpenseView extends GetView<AddExpenseController> {
  const AddExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Amount', style: TextStyle(color: Theme.of(context).hintColor)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('£',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).hintColor)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: controller.amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      filled: false,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((cat) {
                final isSel = controller.selectedCategory.value == cat.name;
                return GestureDetector(
                  onTap: () => controller.selectCategory(cat.name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSel ? AppColors.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: cat.bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(cat.icon, color: cat.iconColor, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Text(cat.name,
                            style: TextStyle(
                                color: isSel ? AppColors.primary : null,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 20),
            const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.titleCtrl,
              decoration: const InputDecoration(hintText: 'e.g. Groceries at Walmart'),
            ),
            const SizedBox(height: 16),
            const Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() => InkWell(
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  Text(DateFormat('dd/MM/yyyy hh:mm a')
                      .format(controller.selectedDate.value)),
                  const Spacer(),
                  const Icon(Icons.calendar_today_outlined, size: 18),
                ]),
              ),
            )),
            const SizedBox(height: 16),
            const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() {
              final loc = controller.pickedLocation.value;
              return Row(children: [
                Expanded(
                  child: InkWell(
                    onTap: controller.openMapPicker,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Icon(
                          loc == null ? Icons.location_on_outlined : Icons.location_on,
                          color: loc == null
                              ? Theme.of(context).hintColor
                              : AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loc?.address ?? 'Pick location on map',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: loc == null
                                  ? Theme.of(context).hintColor
                                  : null,
                            ),
                          ),
                        ),
                        if (loc != null)
                          GestureDetector(
                            onTap: controller.clearLocation,
                            child: Icon(Icons.close,
                                size: 18, color: Theme.of(context).hintColor),
                          ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: controller.isFetchingLocation.value
                      ? null
                      : controller.useCurrentLocation,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: controller.isFetchingLocation.value
                        ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary),
                    )
                        : const Icon(Icons.near_me, color: AppColors.primary),
                  ),
                ),
              ]);
            }),
            const SizedBox(height: 16),
            const Text('Notes (optional)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Add notes...'),
            ),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: controller.isSaving.value ? null : controller.save,
                child: controller.isSaving.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Expense',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(controller.selectedDate.value),
    );
    if (time == null) return;
    controller.setDate(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }
}