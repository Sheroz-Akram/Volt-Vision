import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});
  @override
  State<StatefulWidget> createState() {
    return _About();
  }
}

class _About extends State<About> {
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
                  "About Us - Volt Vision",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Text.rich(
                    textAlign: TextAlign.justify,
                    TextSpan(
                        text:
                            "Welcome to Volt Vision, a pioneering project dedicated to revolutionizing electric meter reading through artificial intelligence. \n \nOur innovative platform utilizes the state-of-the-art YOLO V8 model to deliver an AI-powered solution for efficient, accurate, and reliable electric meter reading. Designed to simplify energy monitoring and management, Volt Vision provides utility companies, energy auditors, and consumers with the tools they need to streamline processes and optimize energy usage. \n\nVolt Vision is more than just technology—it’s a step toward a smarter, sustainable future. With a focus on precision and efficiency, our solution is tailored to tackle real-world challenges, ensuring that meter readings are accurate even in varied and complex scenarios.")),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Our Vision:",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Text.rich(
                    textAlign: TextAlign.justify,
                    TextSpan(
                        text:
                            "To empower individuals and organizations with intelligent energy solutions, enhancing transparency and efficiency in utility management.")),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Who We Are:",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                Text.rich(
                    textAlign: TextAlign.justify,
                    TextSpan(
                        text:
                            "Volt Vision is being developed by Abdul Muqeet (Enroll # 03-134211-002) and Maysam Hussain Ali (Enroll # 03-134211-017) under the expert guidance of Sir Nadeem Sarwar. With a shared passion for innovation, our team is committed to creating impactful technology solutions for modern challenges. \n\nJoin us in transforming energy management with Volt Vision—where AI drives progress, and technology powers change.")),
                SizedBox(
                  height: 40,
                ),
              ]),
        ),
      ),
    );
  }
}
