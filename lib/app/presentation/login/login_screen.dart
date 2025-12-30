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
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Absensi Ekauto Group',
                  style: GlobalHelper.getTextStyle(
                    context,
                    appTextStyle: AppTextStyle.DISPLAY_SMALL,
                  )?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                label: Text('Email'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.password),
                label: Text('Password'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.maxFinite,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text("Login"),
              ),
            ),
          ],
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
