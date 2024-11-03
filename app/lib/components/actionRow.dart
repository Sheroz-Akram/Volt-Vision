import 'package:flutter/material.dart';

class ActionRow extends StatelessWidget {
  const ActionRow({super.key, required this.title, required this.onClick});
  final String title;
  final Function onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: const Color(0xFF1A2632),
      onTap: () {
        onClick();
      },
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: const Color.fromARGB(255, 175, 175, 175)),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Color.fromARGB(255, 175, 175, 175),
            )
          ],
        ),
      ),
    );
  }
}
