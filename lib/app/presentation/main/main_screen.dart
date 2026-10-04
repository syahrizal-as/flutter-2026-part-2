import 'package:absensi_2026/app/presentation/calendar/calendar_screen.dart';
import 'package:absensi_2026/app/presentation/profile/profile_screen.dart';
import 'package:absensi_2026/app/presentation/detail_attendance/detail_attendance_screen.dart';
import 'package:absensi_2026/app/presentation/home/home_screen.dart';
import 'package:absensi_2026/app/presentation/leave/leave_screen.dart';
import 'package:absensi_2026/app/presentation/main/main_notifier.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends AppWidget<MainNotifier, void, void> {
  final List<Widget> _pages = [
    HomeScreen(),
    CalendarScreen(),
    DetailAttendanceScreen(),
    LeaveScreen(),
    ProfileScreen(),
  ];

  @override
  Widget bodyBuild(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: notifier.currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
        height: 72,
        decoration: BoxDecoration(
          color: color.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.primary.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: color.outlineVariant.withOpacity(0.5), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, 0, Icons.home_rounded, "Beranda"),
              _navItem(context, 1, Icons.calendar_month_rounded, "Kalender"),
              _navItem(context, 2, Icons.history_rounded, "Riwayat"),
              _navItem(context, 3, Icons.event_note_rounded, "Izin"),
              _navItem(context, 4, Icons.person_rounded, "Profil"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, IconData icon, String label) {
    final color = Theme.of(context).colorScheme;
    final isSelected = notifier.currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => notifier.currentIndex = index,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? color.primary : color.outline.withOpacity(0.5),
                size: isSelected ? 28 : 24,
              ),
              if (isSelected) ...[
                const SizedBox(height: 4),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.primary,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
