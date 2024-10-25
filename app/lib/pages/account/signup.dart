import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            actions: const [],
          ),
          body: const Column(
            children: [Text("Sign Up Page")],
          )),
    );
  }
}
