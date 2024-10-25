import 'package:app/components/button.dart';
import 'package:app/components/input.dart';
import 'package:app/pages/account/signup.dart';
import 'package:app/pages/dashboard/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool displayPassword = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Image.asset("assets/images/logo.png", fit: BoxFit.fill),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      "Welcome to the future of energy",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Log in to your account or sign up for a new one to get started.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextInput(
                hintText: "Email Address",
                controller: emailController,
              ),
              TextInput(
                hintText: "Password",
                controller: passwordController,
                isPassword: true,
                displayPassword: displayPassword,
                toggleDisplayPassword: () {
                  setState(() {
                    displayPassword = !displayPassword;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      // Move to Password Reset Page
                    },
                    child: Text(
                      "Forgot Password?",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ),
              Button(
                  buttonText: "Log In",
                  onButtonClick: () {
                    // Perform Login
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  }),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: Text(
                  "Sign Up",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          )),
    );
  }
}
