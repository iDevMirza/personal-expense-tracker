import 'package:personal_expense_tracker/services/firebase_service.dart';
import 'package:personal_expense_tracker/services/local_storage_service.dart';

class AppConfig {
  AppConfig._();

  static final AppConfig instance = AppConfig._();

  late FirebaseService _firebaseService;
  late LocalStorageService _localStorageService;

  Future<void> initialize() async{
    _firebaseService = FirebaseService();
    await _firebaseService.initializeFirebase();

    _localStorageService = LocalStorageService.instance;
    await _localStorageService.database;
  }
}