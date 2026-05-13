import 'dart:async';

import 'package:get/get.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/expense_service.dart';

class MainController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final ExpenseService _expenseService = Get.find<ExpenseService>();

  final RxInt selectedTab = 0.obs;

  final RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  final Rxn<UserModel> user = Rxn<UserModel>();

  final RxBool isLoadingUser = false.obs;
  final RxBool isLoadingExpenses = false.obs;

  StreamSubscription<List<ExpenseModel>>? _expenseSubscription;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    await _loadUser();
    _bindExpenses();
  }

  Future<void> _loadUser() async {
    try {
      isLoadingUser.value = true;

      final uid = _auth.currentUser?.uid;

      if (uid == null) {
        user.value = null;
        return;
      }

      final fetchedUser = await _auth.fetchUser(uid);
      user.value = fetchedUser;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load user: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingUser.value = false;
    }
  }

  Future<void> refreshUser() async {
    await _loadUser();
  }

  void _bindExpenses() {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      expenses.clear();
      isLoadingExpenses.value = false;
      return;
    }

    isLoadingExpenses.value = true;

    _expenseSubscription?.cancel();

    _expenseSubscription = _expenseService.watchUserExpenses(uid).listen(
          (list) {
        expenses.assignAll(list);
        isLoadingExpenses.value = false;
      },
      onError: (error) {
        isLoadingExpenses.value = false;

        Get.snackbar(
          'Error',
          'Failed to load expenses: $error',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  void refreshExpenses() {
    _bindExpenses();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  Future<void> deleteExpense(String id) async {
    try {
      final uid = _auth.currentUser?.uid;

      if (uid == null) {
        Get.snackbar(
          'Error',
          'User is not logged in',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await _expenseService.deleteExpense(
        uid: uid,
        expenseId: id,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete expense: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<ExpenseModel> get currentMonthExpenses {
    final now = DateTime.now();

    return expenses.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).toList();
  }

  List<ExpenseModel> get lastMonthExpenses {
    final now = DateTime.now();

    final lastMonthDate = DateTime(
      now.year,
      now.month - 1,
    );

    return expenses.where((expense) {
      return expense.date.year == lastMonthDate.year &&
          expense.date.month == lastMonthDate.month;
    }).toList();
  }

  double get totalThisMonth {
    return currentMonthExpenses.fold(
      0.0,
          (sum, expense) => sum + expense.amount,
    );
  }

  double get totalLastMonth {
    return lastMonthExpenses.fold(
      0.0,
          (sum, expense) => sum + expense.amount,
    );
  }

  double get monthChangePercent {
    if (totalLastMonth == 0) return 0;

    return ((totalThisMonth - totalLastMonth) / totalLastMonth) * 100;
  }

  int get monthCount {
    return currentMonthExpenses.length;
  }

  double get monthAvgPerDay {
    final currentDay = DateTime.now().day;

    if (currentDay == 0) return 0;

    return totalThisMonth / currentDay;
  }

  double get monthHighest {
    if (currentMonthExpenses.isEmpty) return 0;

    return currentMonthExpenses
        .map((expense) => expense.amount)
        .reduce((a, b) => a > b ? a : b);
  }

  double get totalAllTime {
    return expenses.fold(
      0.0,
          (sum, expense) => sum + expense.amount,
    );
  }

  Future<void> signOut() async {
    await _expenseSubscription?.cancel();
    _expenseSubscription = null;

    expenses.clear();
    user.value = null;

    await _auth.signOut();

    Get.delete<MainController>(force: true);
  }

  @override
  void onClose() {
    _expenseSubscription?.cancel();
    super.onClose();
  }
}