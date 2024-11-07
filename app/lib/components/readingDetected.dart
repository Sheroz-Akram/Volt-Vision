import 'dart:convert';

import 'package:app/classes/network.dart';
import 'package:app/components/graph.dart';
import 'package:app/pages/welcome.dart';
import 'package:app/utils/snackBarDisplay.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class ReadingDetected extends StatefulWidget {
  const ReadingDetected({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ReadingDetected();
  }
}

class _ReadingDetected extends State<ReadingDetected> {
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
    DateTime now = DateTime.now();
    return Scaffold(
        appBar: AppBar(
          leading: Image.asset("assets/images/logo.png"),
          centerTitle: true,
          title: const Text("Meter Reading"),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Text(
                    chartData.lastOrNull == null
                        ? "Reading Detected"
                        : "Reading Detected: ${chartData.lastOrNull!.units} kWh",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Text(
                          "Date and time of reading",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat('MMM d, yyyy').format(now),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: const Color(0xFF566575)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat('hh:mm a').format(now),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: const Color(0xFF566575)),
                        ),
                      ],
                    ),
                  ),
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
                                ? "+${chartData.lastOrNull!.change.toInt()}"
                                : "-${chartData.lastOrNull!.change.toInt()}",
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
        ));
  }
}
