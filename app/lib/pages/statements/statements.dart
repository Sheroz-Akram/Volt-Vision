import 'dart:convert';

import 'package:app/classes/network.dart';
import 'package:app/components/statementDownloadOption.dart';
import 'package:app/pages/welcome.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class StatementPage extends StatefulWidget {
  const StatementPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _StatementPage();
  }
}

class StatementData {
  StatementData(this.time, this.billNumber);
  final DateTime time;
  final String billNumber;
}

class _StatementPage extends State<StatementPage> {
  final Network network = Network();
  final Storage storage = Storage();
  String? token = "";

  List<Map<String, dynamic>> statements = [];

  // Parse the Response from Server
  List<Map<String, dynamic>> parseResponse(List<dynamic> serverResponseData) {
    // Group the data by year first
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var value in serverResponseData) {
      // Extract year and create a new DateTime object
      String year = value['year'].toString();
      DateTime date = DateTime(value['year'], value['month'], value['date']);

      // Initialize a new group if it doesn't exist
      groupedData.putIfAbsent(year, () => []);

      // Add the statement with the date
      groupedData[year]!.add({"date": date, "billNumber": value['billNumber']});
    }

    // Transform the grouped data into the desired format
    List<Map<String, dynamic>> result = groupedData.entries.map((entry) {
      return {
        "year": entry.key,
        "statements": entry.value,
      };
    }).toList();

    // Reverse the list to ensure the most recent years come first
    result.sort((a, b) => b['year'].compareTo(a['year']));
    print(result);
    return result;
  }

  // Load Electricity Usage Information From Server
  void loadData() async {
    SnackBarDisplay snackBarDisplay = SnackBarDisplay(context: context);
    token = await storage.loadToken();
    Response response =
        await network.postRequest("meters/readings", {"token": token});
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['success'] == true) {
        setState(() {
          statements = parseResponse(responseBody["readings"]);
        });
      } else {
        snackBarDisplay.showError(responseBody['message']);
      }
    } else {
      if (responseBody['expired'] == true) {
        await storage.removeToken();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false,
        );
      }
      snackBarDisplay.showError(responseBody['message']);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

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
              StatementDownloadOption(
                  date: statement['date'],
                  billNumber: statement['billNumber'],
                  token: token!,
                  baseUrl: network.baseUrl),
          ],
        ],
      ),
    );
  }
}
