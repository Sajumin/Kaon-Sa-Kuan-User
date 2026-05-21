import 'package:flutter/material.dart';
import '../../screens/user/user_homepage.dart';
import '../../screens/user/user_reports_page.dart';
import '../../screens/user/user_add_new.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  static const themeColor = Color(0xFFF28544);

  final List<Widget> _screens = const [
    UserHomepage(),
    UserReportsPage(),
  ];

  void _onAddTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddRestaurantPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          elevation: 8,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'home', 0),
              GestureDetector(
                onTap: _onAddTap,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
              _buildNavItem(Icons.grid_view_rounded, 'reports', 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isActive ? themeColor : themeColor.withOpacity(0.35),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Afacad',
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? themeColor : themeColor.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}