import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isPassword = false,
      this.inputEnable = true,
      this.displayPassword = true,
      this.toggleDisplayPassword});
  final String hintText;
  final bool isPassword;
  final bool displayPassword;
  final bool inputEnable;
  final Function? toggleDisplayPassword;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        width: MediaQuery.of(context).size.width,
        child: TextField(
          enabled: inputEnable,
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
          style: inputEnable
              ? Theme.of(context).textTheme.bodyMedium
              : Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: const Color.fromARGB(255, 151, 151, 151)),
          cursorColor: Colors.white,
        ));
  }
}
