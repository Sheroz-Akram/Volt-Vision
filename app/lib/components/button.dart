import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key, required this.buttonText, required this.onButtonClick});

  final String buttonText;
  final Function onButtonClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          onButtonClick();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(buttonText, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
