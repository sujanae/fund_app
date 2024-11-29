import 'package:flutter/material.dart';
import 'package:fund_app/pages/auth/auth_service.dart';
import 'package:fund_app/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmPasswordcontroller = TextEditingController();

  void register() async {
    final email = _emailcontroller.text;
    final password = _passwordcontroller.text;
    final confirmPassword = _confirmPasswordcontroller.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password Don't Match")));
    }

    try {
      await authService.signUpWithEmailPassword(email, password);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          TextField(
            controller: _emailcontroller,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _passwordcontroller,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: " Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _confirmPasswordcontroller,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(onPressed: register, child: const Text("Register")),
          GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage())),
              child: const Center(child: Text("Already a user? Sign In!")))
        ],
      ),
    );
  }
}
