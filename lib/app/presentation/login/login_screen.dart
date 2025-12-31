import 'package:absensi_2026/app/presentation/home/home_screen.dart';
import 'package:absensi_2026/app/presentation/login/login_notifier.dart';
import 'package:absensi_2026/core/helper/global_helper.dart';
import 'package:absensi_2026/core/widget/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginScreen extends AppWidget<LoginNotifier, void, void> {
  @override
  // void checkVariableAfterUi(BuildContext context) {
  //   if (notifier.isLoged) {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => HomeScreen(),
  //         ));
  //   }
  // }
  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFBEDEA), Color(0xFFFFF7F5)],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),

                /// 🏢 HEADER / BRAND
                Column(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 64,
                      color: Color(0xFF8C3A2B),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Absensi Ekauto Group',
                      style: GlobalHelper.getTextStyle(
                        context,
                        appTextStyle: AppTextStyle.DISPLAY_SMALL,
                      )?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Login untuk mencatat kehadiran',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// 🧾 LOGIN CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// EMAIL
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: 'Email',
                          hintText: 'example@email.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// PASSWORD
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF8C3A2B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// FOOTER
                Text(
                  '© ${DateTime.now().year} Ekauto Group',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _showHidePassword() {
  //   notifier.isShowPassword = !notifier.isShowPassword;
  // }

  // _onPressLogin(BuildContext context) {
  //   notifier.login();
  // }
}
