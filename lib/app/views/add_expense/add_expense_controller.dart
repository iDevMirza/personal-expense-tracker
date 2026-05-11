import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/picked_location.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/expense_service.dart';
import '../../data/services/location_service.dart';
import '../../routes/app_routes.dart';

class AddExpenseController extends GetxController {
  final AuthService _auth = Get.find();
  final ExpenseService _service = Get.find();
  final LocationService _locationService = Get.find();

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
    if (arg is String) selectedCategory.value = arg;
  }

  void selectCategory(String name) => selectedCategory.value = name;
  void setDate(DateTime d) => selectedDate.value = d;

  Future<void> useCurrentLocation() async {
    try {
      isFetchingLocation.value = true;
      final pos = await _locationService.getCurrentPosition();
      if (pos == null) return;
      final addr = await _locationService.getAddressFromCoords(pos.latitude, pos.longitude);
      pickedLocation.value = PickedLocation(
        latitude: pos.latitude,
        longitude: pos.longitude,
        address: addr ?? 'Unknown location',
      );
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<void> openMapPicker() async {
    final result = await Get.toNamed(Routes.locationPicker);
    if (result is PickedLocation) pickedLocation.value = result;
  }

  void clearLocation() => pickedLocation.value = null;

  Future<void> save() async {
    final amount = double.tryParse(amountCtrl.text);
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Enter a valid amount',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar('Error', 'Enter a title', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isSaving.value = true;
      final uid = _auth.currentUser!.uid;
      final loc = pickedLocation.value;

      await _service.addExpense(ExpenseModel(
        id: '',
        userId: uid,
        amount: amount,
        category: selectedCategory.value,
        title: titleCtrl.text.trim(),
        location: loc?.address,
        latitude: loc?.latitude,
        longitude: loc?.longitude,
        notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
        date: selectedDate.value,
      ));
      Get.back();
      Get.snackbar('Success', 'Expense added',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade900);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
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