import 'package:flutter/material.dart';
import '../../widgets/report_card.dart';

class UserReportsPage extends StatefulWidget {
  const UserReportsPage({super.key});

  @override
  State<UserReportsPage> createState() => _UserReportsPageState();
}

class _UserReportsPageState extends State<UserReportsPage> {
  static const themeColor = Color(0xFFF28544);
  final TextEditingController _reportController = TextEditingController();

  // Mock data — replace with Firebase stream later
  final List<String> _reports = [
    "Pwede po pa-remove ng Scarlet's? Matagal na po kasi sila close tapos sinuggest po siya ng app samin. Thank you po!",
  ];

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  void _submitReport() {
    final text = _reportController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _reports.insert(0, text); 
      _reportController.clear();
    });

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
                      Text(
                        'Community Reports',
                        style: const TextStyle(
                          fontFamily: 'Afacad',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Help keep restaurants accurate.',
                        style: const TextStyle(
                          fontFamily: 'Afacad',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Report count badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_reports.length} reports',
                    style: const TextStyle(
                      fontFamily: 'Afacad',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Report Cards 
          Expanded(
            child: _reports.isEmpty
                ? Center(
                    child: Text(
                      'No reports yet. Be the first!',
                      style: const TextStyle(
                          fontFamily: 'Afacad', color: Colors.grey, fontSize: 13),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    itemCount: _reports.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return ReportCard(text: _reports[index]);
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
                      hintStyle: const TextStyle(
                        fontFamily: 'Afacad',
                        color: themeColor,
                        fontSize: 13,
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