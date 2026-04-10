import 'package:firebase_core/firebase_core.dart';
import 'package:personal_expense_tracker/firebase_options.dart';

class FirebaseService {
  FirebaseService._internal();

  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService(){
    return _instance;
  }

  Future<void> initializeFirebase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}