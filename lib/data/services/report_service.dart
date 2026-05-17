import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaon_sa_kuan/models/report.dart';

class ReportService {
  final CollectionReference _reportsCollection = FirebaseFirestore.instance.collection('reports');

  // SEND: Uploads a new report to Firebase
  Future<void> sendReport(String message) async {
    try {
      final newReport = Report(
        message: message,
        createdAt: DateTime.now(),
      );
      await _reportsCollection.add(newReport.toMap());
    } catch (e) {
      print("Error sending report: $e");
      rethrow;
    }
  }

  // FETCH: Gets reports in real-time (newest first)
  Stream<List<Report>> getReports() {
    return _reportsCollection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Report.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
}