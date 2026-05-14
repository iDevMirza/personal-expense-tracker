import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/expense_model.dart';
import '../../data/models/picked_location.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/expense_service.dart';
import '../../data/services/location_service.dart';
import '../../routes/app_routes.dart';
import '../home/main_controller.dart';

class AddExpenseController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final ExpenseService _service = Get.find<ExpenseService>();
  final LocationService _locationService = Get.find<LocationService>();

  final amountCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  final selectedCategory = 'Food'.obs;
  final selectedDate = DateTime.now().obs;
  final pickedLocation = Rxn<PickedLocation>();
  final isSaving = false.obs;
  final isFetchingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;
    if (arg is String && arg.trim().isNotEmpty) {
      selectedCategory.value = arg;
    }
  }

  void selectCategory(String name) {
    selectedCategory.value = name;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  String _coordinateFallback(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  Future<void> useCurrentLocation() async {
    try {
      isFetchingLocation.value = true;

      final position = await _locationService.getCurrentPosition();

      if (position == null) {
        Get.snackbar(
          'Location unavailable',
          'Please enable GPS and allow location permission.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final address = await _locationService.getAddressFromCoords(
        position.latitude,
        position.longitude,
      );

      pickedLocation.value = PickedLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address?.trim().isNotEmpty == true
            ? address!.trim()
            : _coordinateFallback(position.latitude, position.longitude),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get current location: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<void> openMapPicker() async {
    final result = await Get.toNamed(Routes.locationPicker);

    if (result != null) {
      pickedLocation.value = result;
    }
  }

  void clearLocation() {
    pickedLocation.value = null;
  }

  Future<void> save() async {
    final amount = double.tryParse(amountCtrl.text.trim());
    final title = titleCtrl.text.trim();
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      Get.snackbar(
        'Error',
        'You must be logged in to add an expense.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Error',
        'Enter a valid amount',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (title.isEmpty) {
      Get.snackbar(
        'Error',
        'Enter a title',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSaving.value = true;

      final uid = currentUser.uid;
      final location = pickedLocation.value;

      final expense = ExpenseModel(
        id: '',
        userId: uid,
        amount: amount,
        category: selectedCategory.value,
        title: title,
        location: location?.address,
        latitude: location?.latitude,
        longitude: location?.longitude,
        notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
        date: selectedDate.value,
      );

      await _service.addExpense(
        uid: uid,
        expense: expense,
      );

      if (Get.isRegistered<MainController>()) {
        Get.find<MainController>().refreshExpenses();
      }

      Get.back();
      Get.snackbar(
        'Success',
        'Expense added',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add expense: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    titleCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }
}
