import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/expense_model.dart';

class ExpenseService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _expenseCollection(String uid) {
    return _firestore.collection('users').doc(uid).collection('expenses');
  }

  Stream<List<ExpenseModel>> watchUserExpenses(String uid) {
    return _expenseCollection(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(ExpenseModel.fromFirestore).toList();
    });
  }

  Future<DocumentReference<Map<String, dynamic>>> addExpense({
    required String uid,
    required ExpenseModel expense,
  }) {
    return _expenseCollection(uid).add({
      ...expense.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateExpense({
    required String uid,
    required ExpenseModel expense,
  }) {
    if (expense.id.isEmpty) {
      throw ArgumentError('Expense id is required for update');
    }

    return _expenseCollection(uid).doc(expense.id).update(expense.toFirestore());
  }

  Future<void> deleteExpense({
    required String uid,
    required String expenseId,
  }) {
    return _expenseCollection(uid).doc(expenseId).delete();
  }
}
