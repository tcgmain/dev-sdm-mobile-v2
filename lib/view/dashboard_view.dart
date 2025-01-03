import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
//import 'package:sdm/view/stock_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sdm/blocs/territory_wise_visit_block.dart';

class DashboardView extends StatefulWidget {
  final bool isShowingMainData;
  final List weeklySummary;

  const DashboardView({
    super.key,
    required this.weeklySummary,
    required this.isShowingMainData,
  });

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int touchedIndex = -1;
  late TooltipBehavior _tooltipBehavior;
  late TerritoryWiseVisitBlock _territoryWiseVisitBlock;
  List<TerritoryVisitData> chartData = [];

  
  

  List<Map<String, dynamic>> generateDummyData() {
    return [
      {'category': 'Product A', 'value': 30},
      {'category': 'Product B', 'value': 25},
      {'category': 'Product C', 'value': 20},
      {'category': 'Product D', 'value': 15},
      {'category': 'Product E', 'value': 10},
      {'category': 'Product A', 'value': 40},
      {'category': 'Product B', 'value': 50},
      {'category': 'Product C', 'value': 20},
      {'category': 'Product D', 'value': 05},
      {'category': 'Product E', 'value': 10},
      {'category': 'Product A', 'value': 8},
      {'category': 'Product B', 'value': 12},
      {'category': 'Product C', 'value': 20},
      {'category': 'Product D', 'value': 23},
      {'category': 'Product E', 'value': 18},
    ];
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
   _territoryWiseVisitBlock = TerritoryWiseVisitBlock();
   fetchAndDisplayChartData();
    super.initState();
  }

  void fetchAndDisplayChartData() async {
    _territoryWiseVisitBlock.getTerritoryWiseVisits(
      "(9722,77,0)",
       "01/01/2025", 
       "01/01/2025",
    );

    _territoryWiseVisitBlock.territoryWiseVisitStream.listen((response) {
      if (response.status == Status.COMPLETED) {
        setState(() {
          chartData = response.data![0].table!
              .map((tt) => TerritoryVisitData(
                    tt.tterritoryname ?? "Unknown",
                    int.tryParse(tt.tnoofvisit ?? "0") ?? 0,
                  ))
              .toList();
        });
        print("Chart Data Updated: $chartData");
      } else if (response.status == Status.ERROR) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.message}')),
        );
        print("Error: ${response.message}");
      }
    });
  }

  @override
  Widget build(BuildContext context, ) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
          textAlign: TextAlign.left,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 182, 27, 27).withOpacity(0.95),
              const Color.fromARGB(255, 8, 8, 8).withOpacity(0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Text(
                    "Weekly Best Five Selling Product!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      color: CustomColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 150,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 224, 207, 205).withOpacity(0.5),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                   const SizedBox(
                    height: 40,
                     child: 
                       Text(
                        "Teraretry Vice visists",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                   ),

                  SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Card(
                      color: const Color.fromARGB(128, 139, 0, 0).withOpacity(0.05), // Adding a card with opacity
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SfCartesianChart(
                        tooltipBehavior: _tooltipBehavior,
                        series: [
                        BarSeries<TerritoryVisitData, String>(
                          dataSource: chartData,
                          xValueMapper: (TerritoryVisitData  data,_) => data.territoryName, 
                          yValueMapper: (TerritoryVisitData  data,_) => data.visitCount,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(
                              color: CustomColors.textColor,
                            )
                            ),
                          ),
                          
                      ],
                        primaryXAxis: const CategoryAxis(
                          labelStyle: TextStyle(
                            color: CustomColors.textColor,
                          ),
                          title: AxisTitle(text: 'Territories', 
                          textStyle: TextStyle(
                            color: CustomColors.textColor,
                          )),
                        ),
                        primaryYAxis: const NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          labelStyle: TextStyle(
                            color: CustomColors.textColor,
                          ),
                          title: AxisTitle(text: "Number of Visitis",
                          textStyle: TextStyle(
                            color: CustomColors.textColor
                          )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                     child: 
                       Text(
                        "SPO wise Visit",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                   ),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Card(
                      color: const Color.fromARGB(128, 139, 0, 0).withOpacity(0.05), // Adding a card with opacity
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'ID',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Age',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            rows: List.generate(
                              20,
                              (index) => DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      'Person ${index + 1}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${20 + index % 10}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                     child: 
                       Text(
                        "Delayed visit",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: CustomColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                   ),
                  //  SizedBox(
                  //     height: 6000,
                  //     child: LineChart(
                  //        isShowingMainData ? sampleData1 : sampleData2,
                  //        duration: const Duration(milliseconds: 250),
                  //     ),
                  //  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 400,
                      child: Card(
                        color: const Color.fromARGB(128, 139, 0, 0).withOpacity(0.05), // Increased opacity for the card
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: 11,
                              minY: 0,
                              maxY: 6,
                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                getDrawingHorizontalLine: (value) {
                                  return const FlLine(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    strokeWidth: 0.2,
                                  );
                                },
                                drawVerticalLine: true,
                                getDrawingVerticalLine: (value) {
                                  return const FlLine(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    strokeWidth: 0.2,
                                  );
                                },
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(width: 1),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    const FlSpot(0, 3),
                                    const FlSpot(2.6, 2),
                                    const FlSpot(4.9, 5),
                                    const FlSpot(6.8, 2.5),
                                    const FlSpot(8, 4),
                                    const FlSpot(9.5, 3),
                                    const FlSpot(11, 4),
                                  ],
                                  isCurved: false,
                                  barWidth: 3,
                                  belowBarData: BarAreaData(
                                    show: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TerritoryVisitData {
  final String territoryName;
  final int visitCount;

  TerritoryVisitData(this.territoryName, this.visitCount);

  @override
  String toString() {
    return "Territory: $territoryName, Visits: $visitCount";
  }
}