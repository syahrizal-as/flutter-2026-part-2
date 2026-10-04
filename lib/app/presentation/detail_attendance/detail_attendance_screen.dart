import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/presentation/detail_attendance/detail_attendance_notifier.dart';
import 'package:absensi_2026/core/helper/date_time_helper.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class DetailAttendanceScreen
    extends AppWidget<DetailAttendanceNotifier, void, void> {
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Detail Kehadiran'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    context,
                    label: 'Bulan',
                    controller: notifier.monthController,
                    entries: notifier.monthListDropdown,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    context,
                    label: 'Tahun',
                    controller: notifier.yearController,
                    entries: notifier.yearListDropdown,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: () => notifier.search(),
                  icon: const Icon(Icons.search_rounded),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: _buildAttendanceList(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required List<DropdownMenuEntry<int>> entries,
  }) {
    return DropdownMenu<int>(
      expandedInsets: EdgeInsets.zero,
      label: Text(label),
      dropdownMenuEntries: entries,
      controller: controller,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAttendanceList(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    
    if (notifier.listAttendance.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 64, color: color.outline.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              "Tidak ada data kehadiran",
              style: TextStyle(color: color.outline),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      itemCount: notifier.listAttendance.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = notifier.listAttendance[index];
        return _itemAttendance(context, item);
      },
    );
  }

  Widget _itemAttendance(BuildContext context, AttendanceEntity item) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              DateTimeHelper.formatDateTimeFromString(
                dateTimeString: item.date!,
                format: 'dd\nMMM',
              ),
              style: TextStyle(
                color: color.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                _timeRow(context, Icons.login_rounded, "Masuk", item.startTime, color.primary),
                const SizedBox(height: 8),
                _timeRow(context, Icons.logout_rounded, "Pulang", item.endTime, color.outline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeRow(BuildContext context, IconData icon, String label, String time, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 13),
        ),
        const Spacer(),
        Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
