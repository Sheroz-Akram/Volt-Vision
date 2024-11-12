import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StatementDownloadOption extends StatelessWidget {
  const StatementDownloadOption({super.key, required this.date});
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM d, yyyy').format(date),
                style: GoogleFonts.inter(
                    color: const Color(0xFFA5A9AC), fontSize: 15.0),
              ),
              Text(
                "Statement ready for download",
                style: GoogleFonts.inter(
                    color: const Color(0xFF64788D), fontSize: 12.0),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(const Color(0xFF243647))),
            child: Text(
              "Download",
              style: GoogleFonts.inter(color: const Color(0xFF9CA4AC)),
            ),
          )
        ],
      ),
    );
  }
}