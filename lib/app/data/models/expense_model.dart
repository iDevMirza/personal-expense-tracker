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

  ExpenseModel({
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

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'amount': amount,
    'category': category,
    'title': title,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'notes': notes,
    'date': Timestamp.fromDate(date),
  };

  factory ExpenseModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      userId: d['userId'] ?? '',
      amount: (d['amount'] ?? 0).toDouble(),
      category: d['category'] ?? 'Other',
      title: d['title'] ?? '',
      location: d['location'],
      latitude: d['latitude'] != null ? (d['latitude'] as num).toDouble() : null,
      longitude: d['longitude'] != null ? (d['longitude'] as num).toDouble() : null,
      notes: d['notes'],
      date: (d['date'] as Timestamp).toDate(),
    );
  }

  ExpenseModel copyWith({
    String? title,
    double? amount,
    String? category,
    String? location,
    double? latitude,
    double? longitude,
    String? notes,
    DateTime? date,
  }) =>
      ExpenseModel(
        id: id,
        userId: userId,
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