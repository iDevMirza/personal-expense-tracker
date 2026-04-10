import 'package:personal_expense_tracker/core/data/models/expense_model.dart';
import 'package:personal_expense_tracker/services/local_storage_service.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepository {
  final LocalStorageService storage;

  ExpenseRepository(this.storage);

  Future<List<ExpenseModel>> getExpenses(String userId) async {
    final db = await storage.database;

    final rows = await db.query(
      'expenses',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return rows.map(ExpenseModel.fromMap).toList();
  }

  Future<void> addExpense(ExpenseModel expense) async {
    final db = await storage.database;

    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateExpense(String id, Map<String, dynamic> data) async {
    final db = await storage.database;

    await db.update(
      'expenses',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteExpense(String id) async {
    final db = await storage.database;

    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}