import 'package:flutter/material.dart';
import '../../widgets/user/user_report_card.dart';
import 'package:kaon_sa_kuan/models/report.dart';
import 'package:kaon_sa_kuan/data/services/report_service.dart';

class UserReportsPage extends StatefulWidget {
  const UserReportsPage({super.key});

  @override
  State<UserReportsPage> createState() => _UserReportsPageState();
}

class _UserReportsPageState extends State<UserReportsPage> {
  static const themeColor = Color(0xFFF28544);
  final TextEditingController _reportController = TextEditingController();

  // Initialize report service
  final ReportService _reportService = ReportService();

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    final text = _reportController.text.trim();
    if (text.isEmpty) return;

    // Send to Firebase
    await _reportService.sendReport(text);
    _reportController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: themeColor,
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Community Reports',
                        style: TextStyle(
                          fontFamily: 'Afacad',
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Help keep restaurants accurate.',
                        style: TextStyle(
                          fontFamily: 'Afacad',
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                // Report count badge
                StreamBuilder<List<Report>>(
                  stream: _reportService.getReports(),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.length ?? 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$count reports',
                        style: const TextStyle(
                          fontFamily: 'Afacad',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          //Report Cards
          Expanded(
            child: StreamBuilder<List<Report>>(
              stream: _reportService.getReports(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: themeColor));
                }

                final reports = snapshot.data ?? [];

                if (reports.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reports yet. Be the first!',
                      style: TextStyle(
                          fontFamily: 'Afacad',
                          color: Colors.grey,
                          fontSize: 13),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  itemCount: reports.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return ReportCard(
                      text: report.message,
                      timestamp: report.createdAt,
                    );
                  },
                );
              },
            ),
          ),

          //Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.00),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Text field
                Expanded(
                  child: TextField(
                    controller: _reportController,
                    maxLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submitReport(),
                    decoration: InputDecoration(
                      hintText: 'Post an anonymous report...',
                      hintStyle: TextStyle(
                        fontFamily: 'Afacad',
                        color: themeColor.withOpacity(0.5),
                        fontSize: 18,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: themeColor, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: themeColor, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: themeColor, width: 2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Send button
                GestureDetector(
                  onTap: _submitReport,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
