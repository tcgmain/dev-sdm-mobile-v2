import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdm/barChart/bar_data.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sdm/utils/constants.dart';

class DashboardView extends StatefulWidget {
  final List weeklySummary;

  const DashboardView({
    super.key,
    this.weeklySummary = const [],
  });

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.weeklySummary.length; i++) {
      print(widget.weeklySummary[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      monAmount: widget.weeklySummary[0],
      tueAmount: widget.weeklySummary[1],
      wedAmount: widget.weeklySummary[2],
      thursAmount: widget.weeklySummary[3],
      friAmount: widget.weeklySummary[4],
      satAmount: widget.weeklySummary[5],
      sunAmount: widget.weeklySummary[6],
    );

    myBarData.intializeBarData();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:  Text("Dashboard",
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
              Color.fromARGB(255, 182, 27, 27).withOpacity(0.95),
              Color.fromARGB(255, 8, 8, 8).withOpacity(0.95),
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
                              color: Color.fromARGB(255, 224, 207, 205).withOpacity(0.5),
                              
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    child: Text(
                      "SPO and SE Visit in the week",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.textColor,
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      height: 190,
                      child: BarChart(
                        BarChartData(
                          maxY: 10,
                          minY: 0,
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  String text;
                                  switch (value.toInt()) {
                                    case 0:
                                      text = 'Mon';
                                      break;
                                    case 1:
                                      text = 'Tue';
                                      break;
                                    case 2:
                                      text = 'Wed';
                                      break;
                                    case 3:
                                      text = 'Thu';
                                      break;
                                    case 4:
                                      text = 'Fri';
                                      break;
                                    case 5:
                                      text = 'Sat';
                                      break;
                                    case 6:
                                      text = 'Sun';
                                      break;
                                    default:
                                      text = '';
                                  }
                                  return Text(
                                    text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: myBarData.bardata
                              .map(
                                (data) => BarChartGroupData(
                                  x: data.x,
                                  barRods: [
                                    BarChartRodData(
                                      toY: data.y,
                                      color: const Color.fromARGB(
                                          255, 228, 54, 54),
                                      width: 25,
                                      borderRadius: BorderRadius.circular(4),
                                      backDrawRodData: BackgroundBarChartRodData(
                                        show: true,
                                        toY: 10,
                                        color: Colors.grey[300]?.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
