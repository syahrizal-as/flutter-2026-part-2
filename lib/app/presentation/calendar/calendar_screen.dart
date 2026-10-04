import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/presentation/calendar/calendar_notifier.dart';
import 'package:absensi_2026/core/helper/date_time_helper.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends AppWidget<CalendarNotifier, void, void> {
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Kalender Kerja'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        children: [
          _buildCalendarCard(context),
          const SizedBox(height: 16),
          _buildEventList(context),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: color.outlineVariant.withOpacity(0.3)),
      ),
      child: TableCalendar<AttendanceEntity>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: notifier.focusedDay,
        selectedDayPredicate: (day) => isSameDay(notifier.selectedDay, day),
        onDaySelected: notifier.onDaySelected,
        onPageChanged: notifier.onPageChanged,
        holidayPredicate: (day) => notifier.holidays.containsKey(DateTime(day.year, day.month, day.day)),
        eventLoader: (day) => notifier.events[DateTime(day.year, day.month, day.day)] ?? [],
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          leftChevronIcon: Icon(Icons.chevron_left_rounded, color: color.primary),
          rightChevronIcon: Icon(Icons.chevron_right_rounded, color: color.primary),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: color.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: color.primary, fontWeight: FontWeight.bold),
          selectedDecoration: BoxDecoration(
            color: color.primary,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: color.secondary,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
          holidayTextStyle: const TextStyle(color: Colors.red),
          weekendTextStyle: const TextStyle(color: Colors.red),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return null;
            return Positioned(
              bottom: 1,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _getEventColor(events.first),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventList(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final events = notifier.selectedEvents;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text(
              notifier.selectedDay != null
                  ? DateTimeHelper.formatDateTime(
                      dateTime: notifier.selectedDay!,
                      format: 'EEEE, dd MMMM yyyy',
                    )
                  : "Detail Kegiatan",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _buildEventListContent(context, events),
        ],
      ),
    );
  }

  Widget _buildEventListContent(BuildContext context, List<AttendanceEntity> events) {
    final holidayName = notifier.selectedDay != null 
        ? notifier.holidays[DateTime(notifier.selectedDay!.year, notifier.selectedDay!.month, notifier.selectedDay!.day)]
        : null;

    if (events.isEmpty && holidayName == null) {
      return _buildEmptyState(context);
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        if (holidayName != null) _itemHoliday(context, holidayName),
        if (holidayName != null && events.isNotEmpty) const SizedBox(height: 12),
        ...events.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _itemAttendance(context, e),
        )),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _itemHoliday(BuildContext context, String name) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.celebration_rounded, color: Colors.red, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Libur Nasional",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.red.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note_rounded, size: 48, color: color.outline.withOpacity(0.2)),
          const SizedBox(height: 12),
          Text(
            "Tidak ada jadwal/riwayat",
            style: TextStyle(color: color.outline, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _itemAttendance(BuildContext context, AttendanceEntity item) {
    final color = Theme.of(context).colorScheme;
    final statusColor = _getEventColor(item);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.access_time_filled_rounded, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.startTime == "00:00:00" ? "Cuti / Izin" : "Presensi Masuk",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  item.startTime == "00:00:00" ? "Status: ${item.note ?? 'Approved'}" : "Jam: ${item.startTime}",
                  style: TextStyle(color: color.outline, fontSize: 12),
                ),
              ],
            ),
          ),
          if (item.endTime != "00:00:00")
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Pulang", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                Text(item.endTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
        ],
      ),
    );
  }

  Color _getEventColor(AttendanceEntity item) {
    if (item.startTime == "00:00:00") return Colors.blue; // Izin/Cuti
    // Logic for late could go here, but for now just indigo for attendance
    return Colors.indigo;
  }
}
