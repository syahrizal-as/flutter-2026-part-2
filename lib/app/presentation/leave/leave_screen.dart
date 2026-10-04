import 'package:absensi_2026/app/presentation/leave/leave_notifier.dart';
import 'package:absensi_2026/core/helper/date_time_helper.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class LeaveScreen extends AppWidget<LeaveNotifier, void, void> {
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Pengajuan Izin/Cuti'),
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
      child: RefreshIndicator(
        onRefresh: () async => notifier.getHistory(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Formulir Pengajuan",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Silakan lengkapi data berikut untuk mengajukan izin atau cuti.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color.outline,
                    ),
              ),
              const SizedBox(height: 32),
              _buildDateField(
                context,
                label: 'Tanggal Mulai',
                controller: notifier.startDateController,
                icon: Icons.calendar_today_rounded,
              ),
              const SizedBox(height: 20),
              _buildDateField(
                context,
                label: 'Tanggal Selesai',
                controller: notifier.endDateController,
                icon: Icons.event_available_rounded,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: notifier.reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Alasan / Keterangan',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: color.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () => notifier.send(),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'KIRIM PENGAJUAN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                "Riwayat Pengajuan",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildHistoryList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    if (notifier.leaves.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.history_rounded, size: 48, color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(
                "Belum ada riwayat pengajuan",
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifier.leaves.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = notifier.leaves[index];
        final color = Theme.of(context).colorScheme;
        
        Color statusColor;
        switch (item.status.toLowerCase()) {
          case 'approved':
            statusColor = Colors.green;
            break;
          case 'rejected':
            statusColor = Colors.red;
            break;
          default:
            statusColor = Colors.orange;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.outlineVariant.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    item.startDate,
                    style: TextStyle(
                      color: color.outline,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.reason,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Sampai: ${item.endDate}",
                style: TextStyle(
                  color: color.outline,
                  fontSize: 12,
                ),
              ),
              if (item.note != null && item.note!.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 4),
                Text(
                  "Catatan Admin: ${item.note}",
                  style: TextStyle(
                    color: color.primary,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    final color = Theme.of(context).colorScheme;
    return TextField(
      readOnly: true,
      controller: controller,
      onTap: () => _onPressDate(context, controller),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color.primary),
        filled: true,
        fillColor: color.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  void checkVariableAfterUi(BuildContext context) {
    if (notifier.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengajuan berhasil dikirim")),
      );
      // Navigator.pop(context); // Optional: If it's a sub-page in MainScreen, maybe don't pop
    }
  }

  _onPressDate(BuildContext context, TextEditingController controller) async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (dateTime != null) {
      final dateTimeString = DateTimeHelper.formatDateTime(
        dateTime: dateTime,
        format: 'yyyy-MM-dd',
      );
      controller.text = dateTimeString;
    }
  }
}
