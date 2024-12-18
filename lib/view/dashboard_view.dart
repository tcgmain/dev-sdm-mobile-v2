import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sdm/utils/constants.dart';

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
  Widget build(BuildContext context, ) {
    final dummyData = generateDummyData();

      if (widget.weeklySummary.length < 7) {
        return const Scaffold(
          body: Center(
            child: Text(
              "Insufficient data provided!",
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
        );
      }

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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: dummyData
                                .map(
                                  (data) => PieChartSectionData(
                                    color: Colors.primaries[dummyData.indexOf(data) % Colors.primaries.length],
                                    value: data['value'].toDouble(),
                                    title: "${data['value']}%",
                                    radius: touchedIndex == dummyData.indexOf(data) ? 60 : 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                                .toList(),
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                });
                              },
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
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID',
                          style: TextStyle(color: Colors.white),
                          )),

                          DataColumn(label: 
                          Text('Name',
                          style: TextStyle(color: Colors.white),
                          )),

                          DataColumn(label: Text('Age',
                          style: TextStyle(color: Colors.white),
                          )),
                        ],
                        rows: List.generate(
                          20, 
                          (index) => DataRow(cells: [
                            DataCell(Text((index + 1).toString(),
                            style: const TextStyle(color: Colors.white),
                            )),

                            DataCell(Text('Person ${index + 1}',
                            style: const TextStyle(color: Colors.white),
                            )),

                            DataCell(Text('${20 + index % 10}',
                            style: const TextStyle(color: Colors.white),
                            )),
                          ])
                        )
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
                            border: Border.all(width: 1)
                          ),
                           titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return  Text(
                                    value.toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255), // Green color for left axis
                                      fontSize: 10,
                                    ),
                                  );
                                }
                              ),
                            ),
                    
                             bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return  Text(
                                    value.toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255), // Green color for left axis
                                      fontSize: 10,
                                    ),
                                  );
                                }
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
                              )
                            )
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
                              //color: Color.fromARGB(255, 96, 4, 12),
                              belowBarData: BarAreaData(
                                show: true,
                              ),
                              
                            )
                          ]
                        )
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