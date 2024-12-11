import 'dart:math';

import 'package:app/components/electrcityTip.dart';
import 'package:flutter/material.dart';

class EnergyTips extends StatefulWidget {
  const EnergyTips({super.key});
  @override
  State<StatefulWidget> createState() {
    return _EnergyTips();
  }
}

class RandomTips {
  List<Map<String, dynamic>> orgTipList = [
    {
      "title": "Switch to LED Bulbs",
      "description":
          "LED bulbs consume up to 80% less electricity than traditional incandescent bulbs and last longer, saving money on energy and replacements.",
      "savings": "Save up to 80% on electricity costs!",
      "image": "assets/images/eTip01.png"
    },
    {
      "title": "Unplug Devices When Not in Use",
      "description":
          "Electronics like chargers, TVs, and microwaves consume energy even when they’re turned off but plugged in. Unplug them to reduce unnecessary electricity usage.",
      "savings": "Save up to 10% on your energy bill!",
      "image": "assets/images/eTip02.png"
    },
    {
      "title": "Use Energy-Efficient Appliances",
      "description":
          "Opt for appliances with high energy-efficiency ratings (e.g., ENERGY STAR). They use less power while maintaining the same performance level.",
      "savings": "Save up to 30% on energy usage!",
      "image": "assets/images/eTip03.png"
    },
    {
      "title": "Optimize Cooling and Heating",
      "description":
          "Set your air conditioner to a moderate temperature and use fans to circulate air. In winter, use proper insulation to reduce heating needs.",
      "savings": "Save up to 25% on cooling and heating costs!",
      "image": "assets/images/eTip04.png"
    },
    {
      "title": "Turn Off Lights When Not Needed",
      "description":
          "Make it a habit to turn off lights when leaving a room. Installing motion sensors or timers can also help automate this process.",
      "savings": "Save up to 15% on your electricity bill!",
      "image": "assets/images/eTip05.png"
    },
    {
      "title": "Leverage Natural Light and Ventilation",
      "description":
          "During the day, open curtains and use sunlight instead of electric lights. Proper ventilation can reduce the need for fans and AC.",
      "savings": "Save up to 20% on lighting and cooling costs!",
      "image": "assets/images/eTip06.png"
    },
    {
      "title": "Regular Maintenance of Appliances",
      "description":
          "Clean filters in air conditioners, refrigerators, and other appliances regularly. Well-maintained equipment uses less energy to operate efficiently.",
      "savings": "Save up to 10% on energy consumption!",
      "image": "assets/images/eTip07.png"
    }
  ];

  List<Map<String, dynamic>> getRandomTips(int length) {
    var random = Random();
    return List.generate(
        length, (_) => orgTipList[random.nextInt(orgTipList.length)]);
  }
}

class _EnergyTips extends State<EnergyTips> {
  int selected = 0;

  // Get Tips from Storage
  RandomTips randomTips = RandomTips();

  // Store the List Tips Randomly
  List<Map<String, dynamic>> todayTipList = [];
  List<Map<String, dynamic>> weekTipList = [];
  List<Map<String, dynamic>> monthTipList = [];

  List tipList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      todayTipList = randomTips.getRandomTips(3);
      weekTipList = randomTips.getRandomTips(3);
      monthTipList = randomTips.getRandomTips(3);
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
