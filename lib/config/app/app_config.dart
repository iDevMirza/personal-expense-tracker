import 'package:personal_expense_tracker/services/firebase_service.dart';

class AppConfig {
  AppConfig._();

  static final AppConfig instance = AppConfig._();

  late FirebaseService _firebaseService;

  Future<void> initialize() async{
    _firebaseService = FirebaseService();
    await _firebaseService.initializeFirebase();
  }
}