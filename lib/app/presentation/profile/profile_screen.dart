import 'package:absensi_2026/app/presentation/login/login_screen.dart';
import 'package:absensi_2026/app/presentation/profile/profile_notifier.dart';
import 'package:absensi_2026/app/presentation/upload_photo/upload_photo_screen.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends AppWidget<ProfileNotifier, void, void> {
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Profil Saya'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          /// PROFILE HEADER
          Center(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color.primary, width: 2),
                  ),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.primaryContainer,
                    ),
                    child: ClipOval(
                      child: notifier.photoUrl != null
                          ? Image.network(
                              notifier.photoUrl!,
                              fit: BoxFit.cover,
                              key: ValueKey(notifier.photoUrl),
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.person,
                                    size: 60,
                                    color: color.primary,
                                  ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                            )
                          : Icon(Icons.person, size: 60, color: color.primary),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton.filled(
                    onPressed: () => _goToUploadPhoto(context),
                    icon: const Icon(Icons.camera_alt_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: color.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            notifier.name,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            notifier.email,
            style: textTheme.bodyMedium?.copyWith(color: color.outline),
          ),
          const SizedBox(height: 40),

          /// SETTINGS LIST
          _buildMenuItem(
            context,
            icon: Icons.person_outline_rounded,
            title: "Informasi Pribadi",
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.lock_outline_rounded,
            title: "Ubah Password",
            onTap: () {},
          ),
          _buildMenuItem(
            context,
            icon: Icons.notifications_none_rounded,
            title: "Pengaturan Notifikasi",
            onTap: () {},
          ),
          _buildSwitchItem(
            context,
            icon: Icons.fingerprint_rounded,
            title: "Daftarkan Sidik Jari",
            value: notifier.isBiometricEnabled,
            onChanged: (val) async {
              if (val) {
                final status = await notifier.getBiometricStatus();
                if (status == 'READY') {
                  notifier.setBiometricEnabled(true);
                } else if (status == 'NO_BIOMETRICS_ENROLLED') {
                  _showEnableBiometricDialog(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hardware biometrik tidak ditemukan atau tidak didukung di perangkat ini ❌')),
                  );
                }
              } else {
                notifier.setBiometricEnabled(false);
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.help_outline_rounded,
            title: "Pusat Bantuan",
            onTap: () {},
          ),

          const SizedBox(height: 40),

          /// LOGOUT BUTTON
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout_rounded),
              label: const Text(
                "LOGOUT",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: color.error,
                side: BorderSide(color: color.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: color.outlineVariant.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: color.primary),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: color.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: color.outlineVariant.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: color.primary),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: color.outline),
            ],
          ),
        ),
      ),
    );
  }

  void _showEnableBiometricDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Biometrik Belum Aktif"),
        content: const Text(
          "Perangkat Anda belum memiliki data sidik jari atau wajah yang terdaftar. "
          "Silakan daftarkan biometrik Anda di pengaturan sistem HP terlebih dahulu.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Nanti Saja"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.openSecuritySettings();
            },
            child: const Text("Buka Pengaturan"),
          ),
        ],
      ),
    );
  }

  void _goToUploadPhoto(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadPhotoScreen()),
    );
    if (result == true && !notifier.isDispose) {
      notifier
          .refreshPhotoSilently(); // Refresh photo silently (no blank screen)
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.logout();
            },
            child: Text(
              "Ya, Keluar",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void checkVariableAfterUi(BuildContext context) {
    if (notifier.isLoggedOut) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }
}
