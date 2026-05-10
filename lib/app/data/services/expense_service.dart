import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/expense_model.dart';

class ExpenseService extends GetxService {
  final _firestore = FirebaseFirestore.instance;
  CollectionReference get _ref => _firestore.collection('expenses');

  Stream<List<ExpenseModel>> watchUserExpenses(String userId) {
    return _ref
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ExpenseModel.fromDoc).toList());
  }

  Future<void> addExpense(ExpenseModel expense) async {
    await _ref.add(expense.toMap());
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await _ref.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _ref.doc(id).delete();
  }
}