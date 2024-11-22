import 'dart:convert';

import 'package:app/classes/network.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UsagePage extends StatefulWidget {
  const UsagePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _UsagePage();
  }
}

class _UsagePage extends State<UsagePage> {
  bool isUsageFound = false;
  final Network network = Network();
  final Storage storage = Storage();

  Map<String, dynamic> usageData = {
    "monthOfReading": "None",
    "averageUnitsPerDay": 0.0,
    "averageUnitsPerMonth": 0.0,
    "unitsConsumedSoFar": 0.0,
    "daysPassed": 0,
    "daysInMonth": 30,
    "predictedUnits": 0.0,
    "billDetails": {
      "basicCharge": 0.0,
      "serviceCharge": 0.0,
      "tax": 0.0,
      "totalBill": 0.0,
    }
  };

  Widget displayRow(String title, String value) {
    return Row(
      children: [
        Text("$title:\t\t", style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: const Color(0xFFBBBEC0)),
        ),
      ],
    );
  }

  void loadUsageData() async {
    SnackBarDisplay snackBarDisplay = SnackBarDisplay(context: context);
    String? token = await storage.loadToken();
    Response response = await network.getRequest("meters/prediction/$token");
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['success'] == true) {
        setState(() {
          usageData = responseBody["data"];
          isUsageFound = true;
        });
      } else {
        snackBarDisplay.showError(responseBody['message']);
      }
    } else {
      snackBarDisplay.showError(responseBody['message']);
    }
  }

  @override
  void initState() {
    super.initState();
    loadUsageData();
  }

  @override
  Widget build(BuildContext context) {
    if (!isUsageFound) {
      return const Center(
        child: Text("Usage Data Not Found"),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          displayRow("Month", usageData["monthOfReading"]),
          displayRow("Days Passed", usageData["daysPassed"].toString()),
          displayRow("Total Days", usageData["daysInMonth"].toString()),
          const SizedBox(
            height: 10,
          ),
          displayRow("Units/Day", usageData["averageUnitsPerDay"].toString()),
          displayRow(
              "Units Consumed", usageData["unitsConsumedSoFar"].toString()),
          displayRow("Predicted Units", usageData["predictedUnits"].toString()),
          const SizedBox(
            height: 10,
          ),
          displayRow(
              "Basic Charge", "\$ ${usageData["billDetails"]["basicCharge"]}"),
          displayRow("Service Charge",
              "\$ ${usageData["billDetails"]["serviceCharge"]}"),
          displayRow("Tax", "\$ ${usageData["billDetails"]["tax"]}"),
          displayRow(
              "Total Bill", "\$ ${usageData["billDetails"]["totalBill"]}"),
        ],
      ),
    );
  }
}
