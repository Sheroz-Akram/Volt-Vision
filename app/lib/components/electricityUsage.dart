import 'dart:convert';

import 'package:app/classes/network.dart';
import 'package:app/components/graph.dart';
import 'package:app/pages/welcome.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ElectricityUsage extends StatefulWidget {
  const ElectricityUsage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ElectricityUsage();
  }
}

class _ElectricityUsage extends State<ElectricityUsage> {
  List<ElectricityData> chartData = [];

  final Network network = Network();
  final Storage storage = Storage();

  // Parse the Response from Server
  List<ElectricityData> parseResponse(List<dynamic> serverResponseData) {
    List<ElectricityData> result = [];
    for (var value in serverResponseData) {
      result.add(ElectricityData(DateTime(value['year'], value['month']),
          value['reading'], value['percentageChange'] * 1.00, value['status']));
    }
    return result.length <= 5
        ? result
        : result.skip(result.length - 5).toList();
  }

  // Load Electricity Usage Information From Server
  void loadData() async {
    SnackBarDisplay snackBarDisplay = SnackBarDisplay(context: context);
    String? token = await storage.loadToken();
    Response response =
        await network.postRequest("meters/readings", {"token": token});
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['success'] == true) {
        setState(() {
          chartData = parseResponse(responseBody["readings"]);
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
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            "You're using ${chartData.lastOrNull == null ? "-0%" : chartData.lastOrNull!.trend == "positive" ? "${chartData.lastOrNull!.change.toInt()}% less" : "${chartData.lastOrNull!.change.toInt()}% mores"} electricity than last week",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Electricity Consumption",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  chartData.lastOrNull == null
                      ? "0 kWh"
                      : '${chartData.lastOrNull!.units} kWh',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Last Month",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF5C6B7B),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    chartData.lastOrNull == null
                        ? "-0%"
                        : chartData.lastOrNull!.trend == "positive"
                            ? "+${chartData.lastOrNull!.change.toInt()}%"
                            : "-${chartData.lastOrNull!.change.toInt()}%",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: chartData.lastOrNull == null
                            ? const Color.fromARGB(255, 104, 104, 104)
                            : chartData.lastOrNull!.trend == "positive"
                                ? const Color(0xFF156F3E)
                                : const Color.fromARGB(255, 196, 0, 16),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        LineChart(
          chartData: chartData,
        ),
      ],
    );
  }
}
