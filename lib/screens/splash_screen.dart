import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/local_storage_service.dart';
import 'get_started_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkStart();
  }

  Future<void> _checkStart() async {
    await Future.delayed(const Duration(seconds: 2)); 

    final isFirst = await LocalStorageService.isFirstTime();
    final session = Supabase.instance.client.auth.currentSession;

    if (isFirst) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GetStartedScreen()),
      );
    } else if (session != null) {
      await LocalStorageService.setLoginSession(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
