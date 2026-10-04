import 'package:absensi_2026/app/presentation/main/main_screen.dart';
import 'package:absensi_2026/app/presentation/login/login_notifier.dart';
import 'package:absensi_2026/app/presentation/security/security_attendance_screen.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends AppWidget<LoginNotifier, void, void> {
  @override
  void checkVariableAfterUi(BuildContext context) {
    if (notifier.isLoged) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  @override
  Widget bodyBuild(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: Stack(
        children: [
          /// BACKGROUND DECORATION
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: color.primary.withOpacity(0.05),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: color.secondary.withOpacity(0.05),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),

                  /// BRANDING
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: color.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: color.primary.withOpacity(0.3),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Presensi Pro",
                          style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: color.primary,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Ekauto Group Attendance",
                          style: textTheme.bodyLarge?.copyWith(
                            color: color.outline,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// DYNAMIC UI BASED ON BIOMETRIC AVAILABILITY
                  FutureBuilder<bool>(
                    future: notifier.canUseBiometric(),
                    builder: (context, snapshot) {
                      final bool canUseBio = snapshot.data == true;

                      if (canUseBio && !notifier.showManualLogin) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),

                            /// LARGE FINGERPRINT ICON (Like the Screenshot)
                            GestureDetector(
                              onTap: () => notifier.loginWithBiometric(),
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.primary.withOpacity(0.1),
                                  border: Border.all(
                                    color: color.primary.withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.fingerprint_rounded,
                                  size: 100,
                                  color: color.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Sentuh sensor untuk masuk",
                              style: textTheme.bodyMedium?.copyWith(
                                color: color.outline,
                              ),
                            ),
                            const SizedBox(height: 64),

                            /// FALLBACK TO PASSWORD BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton(
                                onPressed: () => notifier.toggleManualLogin(),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  side: BorderSide(
                                    color: color.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  "GUNAKAN PASSWORD",
                                  style: TextStyle(
                                    color: color.primary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      /// STANDARD FORM (If biometric not enabled)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// WELCOME TEXT
                          // Text(
                          //   "Selamat Datang",
                          //   style: textTheme.headlineMedium?.copyWith(
                          //     fontWeight: FontWeight.bold,
                          //     color: color.onSurface,
                          //   ),
                          // ),
                          const SizedBox(height: 8),
                          Text(
                            "Silakan login untuk mengakses akun Anda",
                            style: textTheme.bodyMedium?.copyWith(
                              color: color.outline,
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// FORM FIELDS
                          _buildTextField(
                            context,
                            controller: notifier.emailController,
                            label: "Email Perusahaan",
                            hint: "username@ekauto.com",
                            icon: Icons.alternate_email_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            context,
                            controller: notifier.passwordController,
                            label: "Password",
                            hint: "••••••••",
                            icon: Icons.lock_outline_rounded,
                            isPassword: true,
                            obscureText: !notifier.isShowPassword,
                            onSuffixPressed: () => notifier.isShowPassword =
                                !notifier.isShowPassword,
                          ),

                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("Lupa Password?"),
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// LOGIN BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: FilledButton(
                              onPressed: () => notifier.login(),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 4,
                                shadowColor: color.primary.withOpacity(0.5),
                              ),
                              child: const Text(
                                "MASUK SEKARANG",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  /// SECURITY MODE BUTTON
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SecurityAttendanceScreen()),
                        );
                      },
                      icon: const Icon(Icons.security_rounded, size: 18),
                      label: const Text(
                        "BUKA MODE POS SECURITY",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: color.primary.withOpacity(0.7),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  /// FOOTER
                  Center(
                    child: Text(
                      "v1.0.0 • © ${DateTime.now().year} Ekauto Group",
                      style: textTheme.labelMedium?.copyWith(
                        color: color.outline.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixPressed,
    TextInputType? keyboardType,
  }) {
    final color = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: color.outline.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: color.primary, size: 22),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onSuffixPressed,
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: color.outline,
                      size: 20,
                    ),
                  )
                : null,
            filled: true,
            fillColor: color.primary.withOpacity(0.03),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: color.outlineVariant.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: color.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
