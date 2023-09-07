import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TooltipBehavior _tooltip;
  late List<_ChartData> data;

  Future getDocs() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("payments")
        .where("date", isEqualTo: "2023-08-27")
        // .where("amount", isEqualTo: 300)
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print(a['order_id']);
      data.add(_ChartData(a['order_id'], a['amount']));
    }
  }

  @override
  void initState() {
    getDocs();
    data = [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 60),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14),
      _ChartData('AMC', 14),
    ];

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getDocs();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 600,
                width: double.infinity,
              ),
              Container(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis:
                        NumericAxis(minimum: 0, maximum: 100, interval: 5),
                    tooltipBehavior: _tooltip,
                    series: <ChartSeries<_ChartData, String>>[
                      ColumnSeries<_ChartData, String>(
                          dataSource: data,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'Gold',
                          color: Color.fromRGBO(8, 142, 255, 1))
                    ]),
              ),
            ],
          ),
        ));
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
