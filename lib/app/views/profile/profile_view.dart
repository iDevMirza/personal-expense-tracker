import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/theme_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../home/main_controller.dart';

class ProfileView extends GetView<MainController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetCtrl = TextEditingController();
    final themeService = Get.find<ThemeService>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark]),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Obx(() => Text(
                  (controller.user.value?.username ?? 'U')
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(controller.user.value?.username ?? '',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Obx(() => Text(controller.user.value?.email ?? '',
                style: TextStyle(color: Theme.of(context).hintColor))),
            const SizedBox(height: 24),
            Obx(() => Row(children: [
              _stat(context, Icons.attach_money,
                  '\$${controller.totalAllTime.toStringAsFixed(0)}', 'Total Spent'),
              const SizedBox(width: 10),
              _stat(context, Icons.calendar_today_outlined,
                  '${controller.expenses.length}', 'Transactions'),
              const SizedBox(width: 10),
              _stat(
                  context,
                  Icons.trending_up,
                  '\$${(controller.expenses.isEmpty ? 0 : controller.totalAllTime / controller.expenses.length).toStringAsFixed(0)}',
                  'Avg/Transaction'),
            ])),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Monthly Budget',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: budgetCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: controller.user.value?.monthlyBudget != null &&
                              controller.user.value!.monthlyBudget > 0
                              ? '\$${controller.user.value!.monthlyBudget.toStringAsFixed(0)}'
                              : 'Set budget',
                          prefixText: '\$ ',
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final v = double.tryParse(budgetCtrl.text);
                        if (v == null) return;
                        await Get.find<AuthService>()
                            .updateBudget(controller.user.value!.uid, v);
                        controller.refreshUser();
                        budgetCtrl.clear();
                        Get.snackbar('Saved', 'Budget updated',
                            snackPosition: SnackPosition.BOTTOM);
                      },
                      child: const Text('Save'),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Theme toggle
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Obx(() => SwitchListTile(
                secondary: Icon(themeService.isDark.value
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                title: const Text('Dark Mode',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                value: themeService.isDark.value,
                activeColor: AppColors.primary,
                onChanged: (_) => themeService.toggle(),
              )),
            ),
            const SizedBox(height: 8),
            _tile(context, Icons.settings_outlined, 'Settings', () {}),
            _tile(context, Icons.shield_outlined, 'Privacy', () {}),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text('Sign Out',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                onPressed: () async {
                  await controller.signOut();
                  Get.offAllNamed(Routes.login);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, IconData icon, String value, String label) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(label,
                  style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
            ],
          ),
        ),
      );

  Widget _tile(BuildContext context, IconData icon, String label, VoidCallback onTap) =>
      Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
}