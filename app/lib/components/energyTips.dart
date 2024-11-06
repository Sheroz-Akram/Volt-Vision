import 'package:app/components/electrcityTip.dart';
import 'package:flutter/material.dart';

class EnergyTips extends StatefulWidget {
  const EnergyTips({super.key});
  @override
  State<StatefulWidget> createState() {
    return _EnergyTips();
  }
}

class _EnergyTips extends State<EnergyTips> {
  int selected = 0;

  List<Map<String, dynamic>> todayTipList = [
    {
      "title": "Thermostat tip",
      "description":
          "Based on your energy usage, we recommend setting the thermostat to 68 degrees.",
      "savings": "You can save \$10 a month",
      "image": "assets/images/eTip01.png"
    },
    {
      "title": "Dishwasher tip",
      "description":
          "Based on your energy usage, we recommend running the dishwasher at night.",
      "savings": "You can save \$8 a month",
      "image": "assets/images/eTip02.png"
    },
    {
      "title": "Washer tip",
      "description":
          "Based on your energy usage, we recommend running the washer with cold water.",
      "savings": "You can save \$5 a month",
      "image": "assets/images/eTip03.png"
    }
  ];

  List<Map<String, dynamic>> weekTipList = [
    {
      "title": "Washer tip",
      "description":
          "Based on your energy usage, we recommend running the washer with cold water.",
      "savings": "You can save \$5 a month",
      "image": "assets/images/eTip03.png"
    },
    {
      "title": "Thermostat tip",
      "description":
          "Based on your energy usage, we recommend setting the thermostat to 68 degrees.",
      "savings": "You can save \$10 a month",
      "image": "assets/images/eTip01.png"
    },
  ];

  List<Map<String, dynamic>> monthTipList = [
    {
      "title": "Thermostat tip",
      "description":
          "Based on your energy usage, we recommend setting the thermostat to 68 degrees.",
      "savings": "You can save \$10 a month",
      "image": "assets/images/eTip01.png"
    },
    {
      "title": "Dishwasher tip",
      "description":
          "Based on your energy usage, we recommend running the dishwasher at night.",
      "savings": "You can save \$8 a month",
      "image": "assets/images/eTip02.png"
    },
  ];

  List tipList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      tipList = todayTipList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: () {
              setState(() {
                selected = 0;
                tipList = todayTipList;
              });
            },
            child: Container(
              color: selected == 0 ? const Color(0xFF293038) : null,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Today",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )),
        InkWell(
            onTap: () {
              setState(() {
                selected = 1;
                tipList = weekTipList;
              });
            },
            child: Container(
              color: selected == 1 ? const Color(0xFF293038) : null,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "This Week",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )),
        InkWell(
            onTap: () {
              setState(() {
                selected = 2;
                tipList = monthTipList;
              });
            },
            child: Container(
              color: selected == 2 ? const Color(0xFF293038) : null,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "This Month",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Personalized for you",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          height: 400,
          child: ListView.builder(
            itemCount: tipList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: ElectrcityTip(
                  title: tipList[index]['title'],
                  description: tipList[index]['description'],
                  tipImage: tipList[index]['image'],
                  savings: tipList[index]['savings'],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
