import 'package:absensi_2026/app/presentation/home/home_notifier.dart';
import 'package:absensi_2026/app/presentation/map/map.screen.dart';
import 'package:absensi_2026/core/helper/date_time_helper.dart';
import 'package:absensi_2026/core/helper/global_helper.dart';
import 'package:flutter/material.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';

class HomeScreen extends AppWidget<HomeNotifier, void, void> {
  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _headerLayout(context),
          _todayLayout(context),
          Expanded(child: _thisMonthLayout(context)),
        ],
      ),
    );
  }

  Widget _iconText(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final color = GlobalHelper.getColorSchema(context);

    return Row(
      children: [
        Icon(icon, size: 16, color: color.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color.onSurfaceVariant)),
      ],
    );
  }

  _headerLayout(BuildContext context) {
    final color = GlobalHelper.getColorSchema(context);
    final textTheme = GlobalHelper.getTextStyle(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.primaryContainer,
            child: Icon(Icons.person, color: color.onPrimaryContainer),
          ),
          const SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Syahrizal As",
                  style: textTheme?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _iconText(
                      context,
                      icon: Icons.location_city,
                      label: "Kantor",
                    ),
                    const SizedBox(width: 12),
                    _iconText(
                      context,
                      icon: Icons.access_time,
                      label: "Shift Siang",
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(onPressed: () {}, icon: const Icon(Icons.logout)),
        ],
      ),
    );
  }

  Widget _pill(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final color = GlobalHelper.getColorSchema(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
      ),
    );
  }

  Widget _statusChip(BuildContext context, String label) {
    final color = GlobalHelper.getColorSchema(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white.withOpacity(0.4),
    );
  }

  _todayLayout(BuildContext context) {
    final color = GlobalHelper.getColorSchema(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          /// DATE & STATUS
          Row(
            children: [
              _pill(
                context,
                icon: Icons.calendar_today,
                label: DateTimeHelper.formatDateTime(
                  dateTime: DateTime.now(),
                  format: "EEE, dd MMM yyyy",
                ),
              ),
              const Spacer(),
              _statusChip(context, "WFA"),
            ],
          ),

          const SizedBox(height: 16),

          /// TIME
          Row(
            children: [
              _timeTodayLayout(context, "Masuk", "08:00"),
              _divider(),
              _timeTodayLayout(context, "Pulang", "19:00"),
            ],
          ),

          const SizedBox(height: 20),

          /// BUTTON
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () => _onPressCreateAttendance(context),
              style: FilledButton.styleFrom(
                backgroundColor: color.onPrimary,
                foregroundColor: color.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                "Buat Kehadiran",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onPressCreateAttendance(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
  }

  _timeTodayLayout(BuildContext context, String label, String time) {
    return Expanded(
      child: Column(
        children: [
          Text(
            time,
            style:
                GlobalHelper.getTextStyle(
                  context,
                  appTextStyle: AppTextStyle.HEADLINE_SMALL,
                )?.copyWith(
                  color: GlobalHelper.getColorSchema(context).onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: GlobalHelper.getTextStyle(
              context,
              appTextStyle: AppTextStyle.BODY_MEDIUM,
            )?.copyWith(color: GlobalHelper.getColorSchema(context).onPrimary),
          ),
        ],
      ),
    );
  }

  _thisMonthLayout(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 16, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: GlobalHelper.getColorSchema(context).primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Presensi Sebulan Terakhir",
            style: GlobalHelper.getTextStyle(
              context,
              appTextStyle: AppTextStyle.TITLE_LARGE,
            ),
          ),
          SizedBox(height: 2),
          Container(
            height: 1,
            color: GlobalHelper.getColorSchema(context).primary,
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "Tanggal",
                    style: GlobalHelper.getTextStyle(
                      context,
                      appTextStyle: AppTextStyle.TITLE_SMALL,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Masuk",
                    style: GlobalHelper.getTextStyle(
                      context,
                      appTextStyle: AppTextStyle.TITLE_SMALL,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "Pulang",
                    style: GlobalHelper.getTextStyle(
                      context,
                      appTextStyle: AppTextStyle.TITLE_SMALL,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),

          Container(
            height: 2,
            color: GlobalHelper.getColorSchema(context).primary,
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(vertical: 2),
              height: 1,
              color: GlobalHelper.getColorSchema(context).surface,
            ),
            itemCount: 5,
            itemBuilder: (context, index) => _itemThisMonth(context),
          ),
        ],
      ),
    );
  }

  _itemThisMonth(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: GlobalHelper.getColorSchema(context).primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "01\nDes",
                style:
                    GlobalHelper.getTextStyle(
                      context,
                      appTextStyle: AppTextStyle.TITLE_SMALL,
                    )?.copyWith(
                      color: GlobalHelper.getColorSchema(context).onPrimary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "08:00",
                style: GlobalHelper.getTextStyle(
                  context,
                  appTextStyle: AppTextStyle.TITLE_SMALL,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "16:00",
                style: GlobalHelper.getTextStyle(
                  context,
                  appTextStyle: AppTextStyle.TITLE_SMALL,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
