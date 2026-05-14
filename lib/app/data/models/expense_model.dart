import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String title;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final DateTime date;

  const ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.title,
    this.location,
    this.latitude,
    this.longitude,
    this.notes,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category,
      'title': title,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'date': Timestamp.fromDate(date),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toFirestore() => toMap();

  factory ExpenseModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};

    return ExpenseModel(
      id: doc.id,
      userId: data['userId']?.toString() ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      category: data['category']?.toString() ?? 'Other',
      title: data['title']?.toString() ?? '',
      location: data['location']?.toString(),
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      notes: data['notes']?.toString(),
      date: _parseDate(data['date']),
    );
  }

  factory ExpenseModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ExpenseModel.fromDoc(doc);
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? category,
    String? title,
    String? location,
    double? latitude,
    double? longitude,
    String? notes,
    DateTime? date,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      title: title ?? this.title,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      notes: notes ?? this.notes,
      date: date ?? this.date,
    );
  }
}
