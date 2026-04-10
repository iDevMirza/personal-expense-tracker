import 'package:personal_expense_tracker/core/data/models/user_model.dart';
import 'package:personal_expense_tracker/services/local_storage_service.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepository {
  final LocalStorageService storage;

  AuthRepository(this.storage);

  Future<UserModel?> getCurrentSession() async {
    final db = await storage.database;

    final rows = await db.query(
      'session',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return UserModel.fromSessionMap(rows.first);
  }

  Future<UserModel?> login(String email, String password) async {
    final db = await storage.database;

    final users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (users.isEmpty) return null;

    final user = UserModel.fromMap(users.first);
    await saveSession(user);

    return user;
  }

  Future<UserModel?> register(String name, String email, String password) async {
    final db = await storage.database;

    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (existing.isNotEmpty) return null;

    final newUser = UserModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );

    await db.insert(
      'users',
      {
        'id': newUser.id,
        'name': newUser.name,
        'email': newUser.email,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    await saveSession(newUser);
    return newUser;
  }

  Future<void> saveSession(UserModel user) async {
    final db = await storage.database;

    await db.delete('session');
    await db.insert(
      'session',
      {
        'id': 1,
        'user_id': user.id,
        'name': user.name,
        'email': user.email,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> logout() async {
    final db = await storage.database;
    await db.delete('session');
  }
}