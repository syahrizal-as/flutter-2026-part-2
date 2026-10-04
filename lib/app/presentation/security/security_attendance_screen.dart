import 'package:absensi_2026/app/presentation/security/security_attendance_notifier.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:absensi_2026/core/constant/constant.dart';
import 'package:flutter/material.dart';

class SecurityAttendanceScreen
    extends AppWidget<SecurityAttendanceNotifier, void, void> {
  SecurityAttendanceScreen({super.key});

  @override
  AppBar? appBarBuild(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mode Pos Security",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (notifier.selectedBranch != null)
            Text(
              notifier.selectedBranch!.name,
              style: textTheme.labelSmall?.copyWith(color: color.primary),
            ),
        ],
      ),
      actions: [
        if (notifier.selectedBranch != null &&
            notifier.selectedEmployee == null)
          IconButton(
            onPressed: () => notifier.resetBranch(),
            icon: const Icon(Icons.edit_location_alt_rounded),
            tooltip: "Ganti Lokasi Cabang",
          ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'register') {
              _showAdminAuthDialog(context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'register',
              child: Row(
                children: [
                  Icon(Icons.person_add_alt_1_rounded, color: Colors.blue),
                  SizedBox(width: 12),
                  Text("Daftar Wajah Karyawan"),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.settings_rounded),
        ),
      ],
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return Stack(
      children: [
        notifier.selectedBranch == null
            ? _buildBranchSelection(context)
            : Column(
                children: [
                  if (notifier.isRegisterMode)
                    Container(
                      width: double.infinity,
                      color: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "MODE PENDAFTARAN WAJAH AKTIF. Pilih karyawan untuk didaftarkan.",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          TextButton(
                            onPressed: () => notifier.setRegisterMode(false),
                            child: const Text("BATAL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: notifier.selectedEmployee == null
                        ? _buildEmployeeSearch(context)
                        : _buildFaceRecognitionMode(context),
                  ),
                ],
              ),
        if (notifier.lastSuccessData != null) _buildSuccessOverlay(context),
      ],
    );
  }

  Widget _buildSuccessOverlay(BuildContext context) {
    final data = notifier.lastSuccessData!;
    final color = Theme.of(context).colorScheme;

    return Container(
      color: Colors.black.withOpacity(0.8),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "BERHASIL!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['type'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const Divider(height: 32),
                      if (data['image'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: data['image'],
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        data['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data['time'],
                        style: TextStyle(
                          color: color.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBranchSelection(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final branches = notifier.offices;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_rounded, size: 80, color: color.primary),
            const SizedBox(height: 24),
            const Text(
              "Pilih Lokasi Pos Security",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tentukan cabang aktif untuk device ini",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            if (branches.isEmpty)
              Column(
                children: [
                  const Text("Data Cabang tidak ditemukan atau gagal dimuat."),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => notifier.init(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Coba Lagi"),
                  ),
                ],
              )
            else
              ...branches.map(
                (branch) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton.tonal(
                      onPressed: () => notifier.selectBranch(branch),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        branch.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeSearch(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: notifier.searchController,
            onChanged: (v) => notifier.searchEmployee(v),
            decoration: InputDecoration(
              hintText: "Cari Nama Karyawan...",
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: color.primary.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              suffixIcon: notifier.searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        notifier.searchController.clear();
                        notifier.searchEmployee("");
                      },
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: notifier.filteredEmployees.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final employee = notifier.filteredEmployees[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: color.primary.withOpacity(0.1),
                    child:
                        (employee.imageUrl != null &&
                            employee.imageUrl!.isNotEmpty)
                        ? Image.network(
                            employee.imageUrl!.startsWith('http')
                                ? employee.imageUrl!
                                : "$BASE_URL/storage/${employee.imageUrl}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Text(
                                    employee.name[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                          )
                        : Center(
                            child: Text(
                              employee.name[0],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        employee.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (employee.attendanceStatus != null &&
                        employee.attendanceStatus != 'Belum Absen')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: employee.attendanceStatus == 'Sudah Pulang'
                              ? Colors.grey
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: employee.attendanceStatus == 'Sudah Pulang'
                                ? Colors.grey
                                : Colors.green,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          employee.attendanceStatus!.toUpperCase(),
                          style: TextStyle(
                            color: employee.attendanceStatus == 'Sudah Pulang'
                                ? Colors.white
                                : Colors.green,
                            fontSize: 8,
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Text(
                  employee.email ?? "-",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: employee.attendanceStatus == 'Sudah Pulang'
                    ? const Icon(Icons.check_circle, color: Colors.grey)
                    : const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: employee.attendanceStatus == 'Sudah Pulang'
                    ? null
                    : () => notifier.selectEmployee(employee),
              );
            },
          ),
        ),
        if (notifier.recentLogs.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.surfaceVariant.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Riwayat Terakhir",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ...notifier.recentLogs.map(
                  (log) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: log['type'].contains("MASUK")
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            log['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          log['time'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFaceRecognitionMode(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final employee = notifier.selectedEmployee!;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: color.primary.withOpacity(0.05),
          child: Row(
            children: [
              IconButton(
                onPressed: () => notifier.unselectEmployee(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "ID: ${employee.id}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: notifier.isInArea
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: notifier.isInArea ? Colors.green : Colors.red,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            notifier.isInArea
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: notifier.isInArea
                                ? Colors.green
                                : Colors.red,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notifier.isInArea
                                ? "DALAM AREA"
                                : "LUAR AREA (${notifier.distance.toInt()}m)",
                            style: TextStyle(
                              color: notifier.isInArea
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: DateTime.now().hour < 12
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  notifier.attendanceType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(30),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color.primary.withOpacity(0.2),
                            width: 8,
                          ),
                        ),
                        child: ClipOval(
                          child:
                              notifier.currentImage ??
                              (notifier.refPhotoBytes != null
                                  ? Image.memory(
                                      notifier.refPhotoBytes!,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.face_rounded,
                                      size: 120,
                                      color: color.primary.withOpacity(0.2),
                                    )),
                        ),
                      ),
                      if (notifier.percentMatch > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: notifier.percentMatch >= 70
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${notifier.percentMatch.toStringAsFixed(0)}% Match",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (notifier.currentImage == null)
                    Column(
                      children: [
                        FilledButton.icon(
                          onPressed: notifier.isInArea
                              ? () => notifier.startFaceCapture()
                              : null,
                          icon: const Icon(Icons.camera_alt_rounded),
                          label: Text(
                            notifier.isRegisterMode
                                ? "Ambil Foto Referensi"
                                : "Scan Wajah",
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        if (!notifier.isInArea)
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              "Masuk ke area untuk mengaktifkan kamera",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        if (notifier.isRegisterMode)
                          Column(
                            children: [
                              FilledButton.icon(
                                onPressed: () => _showPasswordDialog(context),
                                icon: const Icon(Icons.cloud_upload_rounded),
                                label: const Text("Daftarkan Wajah Ini"),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () =>
                                    notifier.setRegisterMode(false),
                                child: const Text(
                                  "Batal",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          )
                        else ...[
                          if (notifier.percentMatch < 70 &&
                              notifier.percentMatch != 0)
                            const Text(
                              "Wajah tidak cocok, silakan coba lagi.",
                              style: TextStyle(color: Colors.red),
                            ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () => notifier.startFaceCapture(),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text("Scan Ulang"),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            notifier.refPhotoBytes == null
                ? "Sedang mengunduh foto referensi..."
                : "Dekatkan wajah Anda ke kamera untuk verifikasi otomatis",
            textAlign: TextAlign.center,
            style: TextStyle(color: color.outline, fontSize: 12),
          ),
        ),
      ],
    );
  }

  void _showAdminAuthDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.security_rounded, color: Colors.blue),
            SizedBox(width: 12),
            Text("Otorisasi Admin"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Silakan masukkan password admin untuk masuk ke Mode Pendaftaran Wajah."),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password Admin",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (controller.text == 'admin123') {
                Navigator.pop(context);
                notifier.setRegisterMode(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Mode Pendaftaran Wajah Aktif!"),
                    backgroundColor: Colors.blue,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password Salah!"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Masuk"),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Verifikasi Admin"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Masukkan Password Admin untuk mendaftarkan wajah karyawan ini.",
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.registerEmployeeFace(controller.text);
            },
            child: const Text("Daftarkan"),
          ),
        ],
      ),
    );
  }
}
