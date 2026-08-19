import 'package:flutter/material.dart';

import '../screens/book_screen.dart';
import '../screens/buy_screen.dart';
import '../screens/home_screen.dart';
import '../screens/more_screen.dart';
import '../screens/profile_screen.dart';
import '../services/app_session.dart';
import '../theme/wtr_theme.dart';

/// Root container with the persistent 5-tab bottom bar:
/// Home · Book · Buy · Profile · More.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0; // open on Home

  void _go(int i) => setState(() => _tab = i);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: session,
      builder: (context, _) {
        final p = paletteOf(context);
        return Scaffold(
          backgroundColor: p.bg,
          body: IndexedStack(
            index: _tab,
            children: [
              HomeScreen(onBook: () => _go(1)),
              BookScreen(),
              BuyScreen(),
              ProfileScreen(),
              MoreScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tab,
            onTap: _go,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  activeIcon: Icon(Icons.calendar_today),
                  label: 'Book'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  activeIcon: Icon(Icons.shopping_bag),
                  label: 'Buy'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu_outlined), activeIcon: Icon(Icons.menu), label: 'More'),
            ],
          ),
        );
      },
    );
  }
}
