import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import '../services/sensor_history.dart';
import 'dashboard_page.dart';
import 'stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SensorHistory _history = SensorHistory();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _history.bind(FirebaseService().latestStream());
  }

  @override
  void dispose() {
    _history.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(history: _history),
      StatsPage(history: _history),
    ];
    final titles = ['CORAL MONITOR', 'STATISTICS'];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: _BottomNav(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _BottomNav({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        border: Border(
          top: BorderSide(color: Color(0xFF1F1F1F), width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: 'Dashboard',
              selected: index == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.show_chart,
              activeIcon: Icons.insights,
              label: 'Stats',
              selected: index == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFFEEEEEE) : const Color(0xFF555555);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1A1A1A)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF2A2A2A)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? activeIcon : icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 9,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
