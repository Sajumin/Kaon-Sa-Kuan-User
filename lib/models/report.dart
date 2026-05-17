import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String? id;
  final String message;
  final DateTime createdAt;

  Report({
    this.id,
    required this.message,
    required this.createdAt,
  });

  // Convert Firebase Map to Report Object
  factory Report.fromMap(Map<String, dynamic> data, String documentId) {
    return Report(
      id: documentId,
      message: data['message'] ?? '',
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Convert Report Object to Map to save to Firebase
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'created_at': Timestamp.fromDate(createdAt),
      'receiver_id': 'admin',
    };
  }
}