import 'package:app/classes/user.dart';
import 'package:app/components/button.dart';
import 'package:app/components/input.dart';
import 'package:app/pages/account/signup.dart';
import 'package:app/pages/dashboard/home.dart';
import 'package:flutter/material.dart';

import '../../utils/snackBarDisplay.dart';

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

  final User user = User();

  // Signup function that uses validation class
  void login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    // Use to Display Errors
    final snackBarDisplay = SnackBarDisplay(context: context);

    var response = await user.login(email, password);
    if (response != null) {
      snackBarDisplay.showError(response);
    } else {
      snackBarDisplay.showSuccess("Login Successfully");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

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
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Column(
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
                Align(
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
                Button(
                    buttonText: "Log In",
                    onButtonClick: () {
                      // Perform Login
                      login();
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
            ),
          )),
    );
  }
}
