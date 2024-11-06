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
    return result;
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
                      ? "0 KWH"
                      : '${chartData.lastOrNull!.units} KWH',
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
                    "+20%",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: chartData.lastOrNull == null
                            ? const Color.fromARGB(255, 104, 104, 104)
                            : const Color(0xFF156F3E),
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
