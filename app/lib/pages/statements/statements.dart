import 'package:app/components/statementDownloadOption.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatementPage extends StatefulWidget {
  const StatementPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _StatementPage();
  }
}

class _StatementPage extends State<StatementPage> {
  List<Map<String, dynamic>> statements = [
    {
      "year": "2023",
      "statements": [
        {"date": DateTime(2023, 1, 20)},
        {"date": DateTime(2023, 2, 20)},
        {"date": DateTime(2023, 3, 20)}
      ]
    },
    {
      "year": "2022",
      "statements": [
        {"date": DateTime(2022, 12, 20)},
        {"date": DateTime(2022, 11, 20)},
        {"date": DateTime(2022, 10, 20)}
      ]
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var yearData in statements) ...[
            Text(
              yearData['year'],
              style: GoogleFonts.inter(
                  color: const Color(0xFFC8CACC),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            for (var statement in yearData['statements'])
              StatementDownloadOption(date: statement['date']),
          ],
        ],
      ),
    );
  }
}
