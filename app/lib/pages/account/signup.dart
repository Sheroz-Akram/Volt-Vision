import 'package:app/components/button.dart';
import 'package:app/components/input.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool displayPassword = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Sign Up"),
            centerTitle: true,
            automaticallyImplyLeading: true,
            actions: const [],
          ),
          body: Column(
            children: [
              TextInput(hintText: "Your Name", controller: nameController),
              TextInput(hintText: "Email Address", controller: emailController),
              TextInput(
                hintText: "Create Password",
                controller: passwordController,
                isPassword: true,
                displayPassword: displayPassword,
                toggleDisplayPassword: () {
                  setState(() {
                    displayPassword = !displayPassword;
                  });
                },
              ),
              TextInput(
                hintText: "Confirm Password",
                controller: confirmPasswordController,
                isPassword: true,
                displayPassword: displayPassword,
                toggleDisplayPassword: () {
                  setState(() {
                    displayPassword = !displayPassword;
                  });
                },
              ),
              Button(
                  buttonText: "Sign Up",
                  onButtonClick: () {
                    // Perform Sign Up
                  }),
            ],
          )),
    );
  }
}
