import 'package:flutter/material.dart';

class IconRow extends StatelessWidget {
  const IconRow(
      {super.key,
      required this.icon,
      required this.title,
      required this.onClick});
  final IconData icon;
  final String title;
  final Function onClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: const Color(0xFF1A2632),
        onTap: () {
          onClick();
        },
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xFF1A2632),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(title, style: Theme.of(context).textTheme.labelSmall)
          ],
        ),
      ),
    );
  }
}
