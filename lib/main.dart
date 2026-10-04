import 'package:absensi_2026/app/presentation/splash/splash_screen.dart';
import 'package:absensi_2026/core/di/dependency.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Presensi Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
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
