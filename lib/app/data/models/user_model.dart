class UserModel {
  final String uid;
  final String email;
  final String username;
  final double monthlyBudget;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.monthlyBudget = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'username': username,
    'monthlyBudget': monthlyBudget,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] ?? '',
    email: map['email'] ?? '',
    username: map['username'] ?? '',
    monthlyBudget: (map['monthlyBudget'] ?? 0).toDouble(),
    createdAt: DateTime.parse(map['createdAt']),
  );
}