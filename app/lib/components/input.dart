import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isPassword = false,
      this.displayPassword = true,
      this.toggleDisplayPassword});
  final String hintText;
  final bool isPassword;
  final bool displayPassword;
  final Function? toggleDisplayPassword;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: controller,
          obscureText: displayPassword ? false : true,
          decoration: InputDecoration(
              hintText: hintText,
              suffixIconColor: displayPassword
                  ? const Color(0xFFFFFFFF)
                  : const Color(0xFF607489),
              suffixIcon: isPassword
                  ? InkWell(
                      hoverColor: null,
                      onTap: () {
                        toggleDisplayPassword!();
                      },
                      child: const Icon(Icons.remove_red_eye),
                    )
                  : null),
          style: Theme.of(context).textTheme.bodyMedium,
          cursorColor: Colors.white,
        ));
  }
}
