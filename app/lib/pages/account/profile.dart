import 'dart:convert';

import 'package:app/classes/network.dart';
import 'package:app/components/button.dart';
import 'package:app/components/input.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  // Input Handling Controller
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // Helper Classes
  Network network = Network();
  Storage storage = Storage();

  // Get the Profile Details
  void loadProfileDetails() async {
    SnackBarDisplay snackBarDisplay = SnackBarDisplay(context: context);
    String? token = await storage.loadToken();
    Response response = await network.getRequest("users/profile/$token");
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['success'] == true) {
        nameController.text = responseBody['user']['name'];
        emailController.text = responseBody['user']['email'];
      } else {
        snackBarDisplay.showError(responseBody['message']);
      }
    }
  }

  // Update the profile details
  void updateProfileDetails() async {
    SnackBarDisplay snackBarDisplay = SnackBarDisplay(context: context);
    if (nameController.text.isEmpty) {
      snackBarDisplay.showError("Plese Enter Full Name");
      return;
    }
    String? token = await storage.loadToken();
    Response response = await network.postRequest(
        "users/updateProfile", {"token": token, "name": nameController.text});
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['success'] == true) {
        nameController.text = responseBody['user']['name'];
        emailController.text = responseBody['user']['email'];
        snackBarDisplay.showSuccess(responseBody['message']);
      } else {
        snackBarDisplay.showError(responseBody['message']);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Settings"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextInput(hintText: "Full Name", controller: nameController),
            TextInput(
              hintText: "Email Address",
              controller: emailController,
              inputEnable: false,
            ),
            Button(
                buttonText: "Update",
                onButtonClick: () => {updateProfileDetails()})
          ],
        ),
      ),
    );
  }
}
