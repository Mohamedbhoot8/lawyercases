import 'package:flutter/material.dart';
import 'package:lawyer_cases_app/screens/homepage.dart';
import 'package:lawyer_cases_app/screens/lawer_info_screen.dart';

import 'package:lawyer_cases_app/service.dart/db_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLawyerData();
  }

  Future<void> _checkLawyerData() async {
    await Future.delayed(const Duration(seconds: 2)); 
    final lawyer = await DBHelper().getLawyer(); 

    if (!mounted) return;

    if (lawyer != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LawyerSetupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gavel, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              "الأجندة القضائية",
              style: TextStyle(
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
