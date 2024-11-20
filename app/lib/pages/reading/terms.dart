import 'package:flutter/material.dart';

class TermsService extends StatefulWidget {
  const TermsService({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TermsService();
  }
}

class _TermsService extends State<TermsService> {
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
                "Terms of Service",
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
                          "By using the Volt Vision app, you agree to comply with our terms and conditions. Volt Vision is designed to provide AI-based electric meter reading services to simplify energy monitoring. While we strive for accuracy, the app is provided 'as is,' and we do not guarantee perfect readings under all conditions. Users should verify readings for official purposes and use the app only for lawful and intended purposes.",
                      children: [])),
              SizedBox(
                height: 20,
              ),
              Text.rich(
                  textAlign: TextAlign.justify,
                  TextSpan(
                      children: [
                        TextSpan(
                            children: [],
                            text: "help.voltvision@gmail.com. ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                        TextSpan(text: "Thank you for choosing Volt Vision!")
                      ],
                      text:
                          "We reserve the right to update these terms at any time. By continuing to use the app after any updates, you accept the revised terms. For support or inquiries, please contact us at ")),
            ],
          ),
        ),
      ),
    );
  }
}
