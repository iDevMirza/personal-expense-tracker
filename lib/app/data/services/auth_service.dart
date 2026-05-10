import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authState => _auth.authStateChanges();

  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = UserModel(
      uid: cred.user!.uid,
      email: email,
      username: username,
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
    return user;
  }

  Future<UserModel> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _firestore.collection('users').doc(cred.user!.uid).get();
    return UserModel.fromMap(doc.data()!);
  }

  Future<UserModel?> fetchUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateBudget(String uid, double budget) async {
    await _firestore.collection('users').doc(uid).update({'monthlyBudget': budget});
  }

  Future<void> signOut() => _auth.signOut();
}