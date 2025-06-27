import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final supabaseService = SupabaseService();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (isLogin) {
        await supabaseService.signIn(emailController.text, passwordController.text);
      } else {
        await supabaseService.signUp(emailController.text, passwordController.text);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email atau Password anda belum terdaftar. Silahkan coba lagi")));
     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Auth error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login User' : 'Registrasi Akun')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Email wajib diisi' : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Minimal 6 karakter' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin
                    ? 'Belum punya akun? Daftar'
                    : 'Sudah punya akun? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
