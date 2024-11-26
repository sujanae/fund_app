import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fund_app/pages/auth/auth_service.dart';
import 'package:fund_app/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  void login() async {
    final email = _emailcontroller.text;
    final password = _passwordcontroller.text;

    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(onPressed: login, child: const Text("Login")),
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterPage())),
              child:
                  const Center(child: Text("Don't have an account? Sign Up")))
        ],
      ),
    );
  }
}
