import 'package:absensi_2026/app/presentation/login/login_screen.dart';
import 'package:absensi_2026/core/di/dependency.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('id', null);
  await initDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      home: LoginScreen(),
      // home: Scaffold(
      //   body: ErrorAppWidget(
      //     description: 'Error API Absensi',
      //     onPressDefaultButton: () {
      //       print("Refresh API");
      //     },
      //     alternatifButton: FilledButton(
      //       onPressed: () {
      //         print("Kembali");
      //       },
      //       child: Text("Kembali"),
      //     ),
      //   ),
      // ),
    );
  }
}
