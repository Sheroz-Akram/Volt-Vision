import 'package:app/classes/user.dart';
import 'package:app/components/button.dart';
import 'package:app/components/input.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});
  @override
  State<PasswordResetPage> createState() {
    return _PasswordResetPage();
  }
}

class _PasswordResetPage extends State<PasswordResetPage> {
  final TextEditingController emailController = TextEditingController();

  final User user = User();

  // Signup function that uses validation class
  void reset() async {
    final String email = emailController.text;

    // Use to Display Errors
    final snackBarDisplay = SnackBarDisplay(context: context);

    // Perform Sign Up
    var response = await user.resetPassword(email);
    if (response != null) {
      snackBarDisplay.showError(response);
    } else {
      snackBarDisplay.showSuccess("Password Reset Link Send. Check Email");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Reset Password"),
            centerTitle: true,
            automaticallyImplyLeading: true,
            actions: const [],
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "To reset your password. Please provide your email address.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                TextInput(
                    hintText: "Email Address", controller: emailController),
                Button(
                    buttonText: "Sign Up",
                    onButtonClick: () {
                      reset();
                    }),
              ],
            ),
          )),
    );
  }
}
