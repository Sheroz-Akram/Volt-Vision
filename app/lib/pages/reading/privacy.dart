import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});
  @override
  State<StatefulWidget> createState() {
    return _PrivacyPolicy();
  }
}

class _PrivacyPolicy extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              Text.rich(
                  textAlign: TextAlign.justify,
                  TextSpan(
                      style: TextStyle(fontSize: 18),
                      text:
                          "At Volt Vision, your privacy is our priority. We collect essential data, such as meter images, usage logs, and basic account information, to provide and improve our AI-powered meter reading services. Your data is securely stored and will never be shared with third parties without your consent, except as required by law.",
                      children: [])),
              SizedBox(
                height: 20,
              ),
              Text.rich(
                  textAlign: TextAlign.justify,
                  TextSpan(
                      children: [
                        TextSpan(
                            text: "help.voltvision@gmail.com.",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))
                      ],
                      text:
                          "By using our app, you agree to this policy and any updates we may make. If you have questions or concerns, feel free to contact us at ")),
            ],
          ),
        ),
      ),
    );
  }
}
