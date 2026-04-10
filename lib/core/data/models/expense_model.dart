class ExpenseModel {
  final String id;
  final String userId;
  final double amount;
  final String date;
  final String? title;
  final String? category;
  final String? location;
  final String? notes;

  const ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
    this.title,
    this.category,
    this.location,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'date': date,
      'title': title,
      'category': category,
      'location': location,
      'notes': notes,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      title: map['title'] as String?,
      category: map['category'] as String?,
      location: map['location'] as String?,
      notes: map['notes'] as String?,
    );
  }

  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? date,
    String? title,
    String? category,
    String? location,
    String? notes,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      notes: notes ?? this.notes,
    );
  }
}