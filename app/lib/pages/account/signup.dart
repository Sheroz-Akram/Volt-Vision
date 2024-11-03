import 'package:app/classes/user.dart';
import 'package:app/components/button.dart';
import 'package:app/components/input.dart';
import 'package:app/pages/dashboard/home.dart';
import 'package:app/utils/snackBarDisplay.dart';
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

  final User user = User();

  // Signup function that uses validation class
  void signup() async {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // Use to Display Errors
    final snackBarDisplay = SnackBarDisplay(context: context);

    if (password != confirmPassword) {
      snackBarDisplay.showError("Passwords do not match");
      return;
    }

    // Perform Sign Up
    var response = await user.signup(name, email, password);
    if (response != null) {
      snackBarDisplay.showError(response);
    } else {
      snackBarDisplay.showSuccess("Account Created Successfully");
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
            title: const Text("Sign Up"),
            centerTitle: true,
            automaticallyImplyLeading: true,
            actions: const [],
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                TextInput(hintText: "Your Name", controller: nameController),
                TextInput(
                    hintText: "Email Address", controller: emailController),
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
                      signup();
                    }),
              ],
            ),
          )),
    );
  }
}
