import 'package:absensi_2026/app/presentation/login/login_screen.dart';
import 'package:absensi_2026/core/helper/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

class ErrorAppWidget extends StatelessWidget {
  final String description;
  final void Function() onPressDefaultButton;
  final FilledButton? alternatifButton;

  const ErrorAppWidget({
    super.key,
    required this.description,
    required this.onPressDefaultButton,
    this.alternatifButton,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    bool isUnauthenticated = description.contains('401') || description.toLowerCase().contains('unauthenticated');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isUnauthenticated ? color.errorContainer : color.surfaceVariant.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnauthenticated ? Icons.lock_person_rounded : Icons.cloud_off_rounded,
                size: 80,
                color: isUnauthenticated ? color.error : color.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              isUnauthenticated ? "Sesi Berakhir" : "Ups! Terjadi Masalah",
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: textTheme.bodyMedium?.copyWith(color: color.outline),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: alternatifButton ??
                  (isUnauthenticated
                      ? FilledButton.icon(
                          onPressed: () async {
                            await SharedPreferencesHelper.logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.login_rounded),
                          label: const Text("LOGIN ULANG", style: TextStyle(fontWeight: FontWeight.bold)),
                          style: FilledButton.styleFrom(
                            backgroundColor: color.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        )
                      : FilledButton.icon(
                          onPressed: onPressDefaultButton,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text("COBA LAGI", style: TextStyle(fontWeight: FontWeight.bold)),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        )),
            ),
            if (!isUnauthenticated)
              TextButton(
                onPressed: () {},
                child: Text("Hubungi Bantuan", style: TextStyle(color: color.primary)),
              ),
          ],
        ),
      ),
    );
  }
}
