import 'package:get/get.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/expense_service.dart';

class MainController extends GetxController {
  final AuthService _auth = Get.find();
  final ExpenseService _expenseService = Get.find();

  final selectedTab = 0.obs;
  final expenses = <ExpenseModel>[].obs;
  final user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _bindExpenses();
  }

  void _loadUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    user.value = await _auth.fetchUser(uid);
  }

  void refreshUser() => _loadUser();

  void _bindExpenses() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    expenses.bindStream(_expenseService.watchUserExpenses(uid));
  }

  void changeTab(int i) => selectedTab.value = i;

  Future<void> deleteExpense(String id) async {
    await _expenseService.deleteExpense(id);
  }

  // --- Aggregations ---
  double get totalThisMonth {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get totalLastMonth {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    return expenses
        .where((e) => e.date.year == lastMonth.year && e.date.month == lastMonth.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get monthChangePercent {
    if (totalLastMonth == 0) return 0;
    return ((totalThisMonth - totalLastMonth) / totalLastMonth) * 100;
  }

  int get monthCount {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .length;
  }

  double get monthAvgPerDay {
    if (monthCount == 0) return 0;
    return totalThisMonth / DateTime.now().day;
  }

  double get monthHighest {
    final now = DateTime.now();
    final monthExp = expenses.where(
            (e) => e.date.year == now.year && e.date.month == now.month);
    if (monthExp.isEmpty) return 0;
    return monthExp.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }

  double get totalAllTime => expenses.fold(0.0, (sum, e) => sum + e.amount);

  Future<void> signOut() async {
    await _auth.signOut();
  }
}