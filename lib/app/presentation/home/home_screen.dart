import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/presentation/detail_attendance/detail_attendance_screen.dart';
import 'package:absensi_2026/app/presentation/face_recognition/face_recognition_screen.dart';
import 'package:absensi_2026/app/presentation/home/home_notifier.dart';
import 'package:absensi_2026/app/presentation/map/map.screen.dart';
import 'package:absensi_2026/app/presentation/leave/leave_screen.dart';
import 'package:absensi_2026/app/presentation/login/login_screen.dart';
import 'package:absensi_2026/app/presentation/announcement/detail_announcement_screen.dart';
import 'package:absensi_2026/core/helper/date_time_helper.dart';
import 'package:absensi_2026/core/helper/global_helper.dart';
import 'package:absensi_2026/core/helper/shared_preferences_helper.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends AppWidget<HomeNotifier, void, void> {
  bool _isLate(String startTime, String? scheduleStartTime) {
    if (startTime == "-" || scheduleStartTime == null) return false;
    try {
      final actual = DateTime.parse("2026-01-01 $startTime");
      final scheduled = DateTime.parse("2026-01-01 $scheduleStartTime");
      return actual.isAfter(scheduled);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget bodyBuild(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      color: color.surface,
      child: Stack(
        children: [
          // Background Decorations
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.primary.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.secondary.withOpacity(0.03),
              ),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => notifier.init(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _headerLayout(context),
                    const SizedBox(height: 32),
                    _todayLayout(context),
                    const SizedBox(height: 24),
                    _announcementLayout(context),
                    const SizedBox(height: 24),
                    _summaryLayout(context),
                    const SizedBox(height: 32),
                    _historyHeader(context),
                    const SizedBox(height: 16),
                    _thisMonthLayout(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _headerLayout(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      children: [
        // Avatar with Premium Border
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.primary, color.primary.withOpacity(0.2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color.surface,
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: notifier.photoUrl != null
                    ? Image.network(
                        notifier.photoUrl!,
                        fit: BoxFit.cover,
                        key: ValueKey(notifier.photoUrl),
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person_rounded,
                          color: color.primary,
                          size: 30,
                        ),
                      )
                    : Icon(
                        Icons.person_rounded,
                        color: color.primary,
                        size: 30,
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang,",
                style: TextStyle(
                  color: color.outline,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                notifier.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.business_rounded,
                            size: 12,
                            color: color.primary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              notifier.schedule?.office.name ?? "-",
                              style: TextStyle(
                                color: color.onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Location Status Indicator
                  if (notifier.isLocationChecking)
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color.primary,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (notifier.isPermissionDenied ||
                                notifier.isServiceDisabled ||
                                notifier.isOutsideArea
                                ? color.error
                                : Colors.green)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: (notifier.isPermissionDenied ||
                                  notifier.isServiceDisabled ||
                                  notifier.isOutsideArea
                                  ? color.error
                                  : Colors.green)
                              .withOpacity(0.2),
                        ),
                      ),
                      child: InkWell(
                        onTap: (notifier.isPermissionDenied ||
                                notifier.isServiceDisabled)
                            ? () => notifier.checkLocationBeforeAttendance()
                            : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              (notifier.isPermissionDenied ||
                                      notifier.isServiceDisabled ||
                                      notifier.isOutsideArea)
                                  ? Icons.location_off_rounded
                                  : Icons.location_on_rounded,
                              size: 10,
                              color: (notifier.isPermissionDenied ||
                                      notifier.isServiceDisabled ||
                                      notifier.isOutsideArea)
                                  ? color.error
                                  : Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              notifier.isPermissionDenied
                                  ? "Izin Diperlukan"
                                  : notifier.isServiceDisabled
                                      ? "GPS Mati"
                                      : notifier.isOutsideArea
                                          ? "Luar Area"
                                          : "Dalam Area",
                              style: TextStyle(
                                color: (notifier.isPermissionDenied ||
                                        notifier.isServiceDisabled ||
                                        notifier.isOutsideArea)
                                    ? color.error
                                    : Colors.green,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // Logout Button with subtle glass effect
        Material(
          color: color.errorContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => _onPressLogout(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.error.withOpacity(0.1)),
              ),
              child: Icon(Icons.logout_rounded, color: color.error, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  _announcementLayout(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final announcements = [
      {
        "title": "Libur Nasional Hari Buruh",
        "desc": "Kantor akan diliburkan pada 1 Mei 2026. Selamat beristirahat!",
        "date": "1 Mei 2026",
        "icon": Icons.celebration_rounded,
        "color": Colors.orange,
      },
      {
        "title": "Maintenance Server Tahunan",
        "desc": "Akses aplikasi mungkin terganggu pada Sabtu malam pkl 22:00.",
        "date": "2 Mei 2026",
        "icon": Icons.settings_suggest_rounded,
        "color": Colors.blue,
      },
      {
        "title": "Update Kebijakan WFH",
        "desc": "Kebijakan baru akan berlaku mulai 1 Juni 2026. Cek email Anda.",
        "date": "1 Juni 2026",
        "icon": Icons.home_work_rounded,
        "color": Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pengumuman Terbaru",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Lihat Semua",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: announcements.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = announcements[index];
              final itemColor = item['color'] as Color;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailAnnouncementScreen(announcement: item),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          itemColor.withOpacity(0.8),
                          itemColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: itemColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Icon(
                            item['icon'] as IconData,
                            size: 80,
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['date'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['desc'] as String,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _todayLayout(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.primary,
            color.primary.withBlue(color.primary.blue + 30),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateTimeHelper.formatDateTime(
                      dateTime: DateTime.now(),
                      format: "EEEE, dd MMMM",
                    ),
                    style: TextStyle(
                      color: color.onPrimary.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    notifier.currentTime,
                    style: TextStyle(
                      color: color.onPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "LIVE",
                        style: TextStyle(
                          color: color.onPrimary.withOpacity(0.7),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.onPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _timeBox(
                context,
                label: "MASUK",
                time: notifier.attendanceToday?.startTime ?? "--:--",
                isDone: notifier.hasCheckedIn,
                icon: Icons.login_rounded,
              ),
              Container(
                width: 1,
                height: 40,
                color: color.onPrimary.withOpacity(0.2),
              ),
              _timeBox(
                context,
                label: "PULANG",
                time: notifier.attendanceToday?.endTime ?? "--:--",
                isDone: notifier.hasCheckedOut,
                icon: Icons.logout_rounded,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: notifier.canCreateAttendance
                  ? () => _onPressCreateAttendance(context)
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: notifier.canCreateAttendance
                    ? color.onPrimary
                    : color.onPrimary.withOpacity(0.4),
                foregroundColor: color.primary,
                disabledBackgroundColor: color.onPrimary.withOpacity(0.3),
                disabledForegroundColor: color.onPrimary.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    !notifier.hasCheckedIn
                        ? Icons.login_rounded
                        : !notifier.hasCheckedOut
                        ? Icons.logout_rounded
                        : Icons.check_circle_rounded,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    notifier.attendanceButtonLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _summaryLayout(BuildContext context) {
    return Row(
      children: [
        _summaryCard(
          context,
          label: "Hadir",
          count: notifier.totalHadir.toString(),
          color: Colors.blue,
          icon: Icons.calendar_today_rounded,
        ),
        const SizedBox(width: 12),
        _summaryCard(
          context,
          label: "Terlambat",
          count: notifier.totalTerlambat.toString(),
          color: Colors.red,
          icon: Icons.timer_rounded,
        ),
        const SizedBox(width: 12),
        _summaryCard(
          context,
          label: "Izin",
          count: notifier.totalIzin.toString(),
          color: Colors.orange,
          icon: Icons.edit_calendar_rounded,
        ),
      ],
    );
  }

  Widget _summaryCard(
    BuildContext context, {
    required String label,
    required String count,
    required Color color,
    required IconData icon,
  }) {
    final themeColor = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeColor.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: themeColor.outlineVariant.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              count,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: themeColor.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: themeColor.outline,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeBox(
    BuildContext context, {
    required String label,
    required String time,
    bool isDone = false,
    IconData icon = Icons.access_time_rounded,
  }) {
    final color = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isDone ? Icons.check_circle_rounded : icon,
                color: isDone
                    ? Colors.green.withOpacity(0.9)
                    : color.onPrimary.withOpacity(0.6),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color.onPrimary.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              color: color.onPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (label == "MASUK" &&
              isDone &&
              _isLate(time, notifier.schedule?.shift.startTime))
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade900.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "TERLAMBAT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  _historyHeader(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aktivitas Kehadiran",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Rekap 5 hari terakhir",
              style: TextStyle(color: color.outline, fontSize: 12),
            ),
          ],
        ),
        TextButton(
          onPressed: () => _onPressSeeAll(context),
          style: TextButton.styleFrom(
            foregroundColor: color.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: color.primary.withOpacity(0.1)),
            ),
          ),
          child: const Text(
            "Lihat Semua",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }

  _thisMonthLayout(BuildContext context) {
    if (notifier.listAttendanceThisMonth.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.history_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "Belum ada aktivitas bulan ini",
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final reversedList = notifier.listAttendanceThisMonth.reversed.toList();
    final itemCount = reversedList.length > 5 ? 5 : reversedList.length;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final item = reversedList[index];
        return _attendanceItem(context, item, isLast: index == itemCount - 1);
      },
    );
  }

  Widget _attendanceItem(
    BuildContext context,
    AttendanceEntity item, {
    bool isLast = false,
  }) {
    final color = Theme.of(context).colorScheme;
    final isLate = _isLate(item.startTime, notifier.schedule?.shift.startTime);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: color.outlineVariant.withOpacity(0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateTimeHelper.formatDateTimeFromString(
                            dateTimeString: item.date!,
                            format: 'EEEE, dd MMM',
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _miniTimeBox(
                              context,
                              "In",
                              item.startTime,
                              isLate ? Colors.red : Colors.green,
                            ),
                            const SizedBox(width: 12),
                            _miniTimeBox(
                              context,
                              "Out",
                              item.endTime,
                              color.outline,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (isLate ? Colors.red : Colors.green).withOpacity(
                          0.1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isLate ? "LATE" : "ON TIME",
                        style: TextStyle(
                          color: isLate ? Colors.red : Colors.green,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniTimeBox(
    BuildContext context,
    String label,
    String time,
    Color color,
  ) {
    return Row(
      children: [
        Text(
          "$label:",
          style: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          time,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  _onPressCreateAttendance(BuildContext context) async {
    // 1. Pre-Check Lokasi
    final bool isLocationValid = await notifier.checkLocationBeforeAttendance();
    if (!isLocationValid) {
      if (notifier.isOutsideArea && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
        ).then((value) {
          if (value == true) notifier.init(); // Refresh jika absen berhasil di map
        });
      }
      return; // Stop jika lokasi tidak valid
    }

    final color = Theme.of(context).colorScheme;
    
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: color.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Pilih Metode Verifikasi",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Silakan pilih metode untuk melakukan absensi",
              style: TextStyle(color: color.outline, fontSize: 14),
            ),
            const SizedBox(height: 32),
            
            /// OPTION 1: FACE RECOGNITION
            _buildMethodItem(
              context,
              title: "Verifikasi Wajah",
              subtitle: "Gunakan kamera untuk scan wajah",
              icon: Icons.face_retouching_natural_rounded,
              color: color.primary,
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FaceRecognitionScreen()),
                );
                notifier.init();
              },
            ),
            
            const SizedBox(height: 16),
            
            /// OPTION 2: BIOMETRIC (If Enabled)
            if (notifier.isBiometricEnabled)
              _buildMethodItem(
                context,
                title: "Sidik Jari / Biometrik",
                subtitle: "Verifikasi cepat dengan sensor HP",
                icon: Icons.fingerprint_rounded,
                color: Colors.orange.shade700,
                onTap: () async {
                  Navigator.pop(context);
                  await notifier.processBiometricAttendance();
                },
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.outlineVariant.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: color.outline, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Aktifkan Sidik Jari di menu Profile untuk absen lebih cepat.",
                        style: TextStyle(color: color.outline, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final themeColor = Theme.of(context).colorScheme;
    return Material(
      color: themeColor.surfaceVariant.withOpacity(0.3),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: themeColor.outlineVariant.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: themeColor.outline,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: themeColor.outline.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPressSeeAll(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailAttendanceScreen()),
    );
    notifier.init();
  }

  _onPressLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SharedPreferencesHelper.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }
}
