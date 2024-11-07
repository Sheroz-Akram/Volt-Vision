import 'dart:convert';

import 'package:app/classes/network.dart';
import 'package:app/components/button.dart';
import 'package:app/components/readingDetected.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key, required this.uploadImageLocation});
  final String uploadImageLocation;
  @override
  State<StatefulWidget> createState() {
    return _ProcessPage();
  }
}

class _ProcessPage extends State<ProcessPage> {
  void processImage() async {
    Network network = Network();
    Storage storage = Storage();
    String? token = await storage.loadToken();
    final url = Uri.parse('${network.baseUrl}/meters/process');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'filePath': widget.uploadImageLocation, 'token': token}),
    );
    try {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        SnackBarDisplay(context: context).showSuccess(jsonResponse['message']);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ReadingDetected()));
      } else {
        SnackBarDisplay(context: context).showError(jsonResponse['message']);
      }
    } catch (e) {
      SnackBarDisplay(context: context).showError("Network/Invalid Request");
    }
  }

  @override
  void initState() {
    super.initState();
    processImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/images/logo.png"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/processHeader.png"),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                "Processing your reading...",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Button(
            buttonText: "Cancel",
            onButtonClick: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
