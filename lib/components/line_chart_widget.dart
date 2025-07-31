import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaginatedIncomeBarChart extends StatefulWidget {
  final Map<String, double> dataMap;
  final String labelType;

  const PaginatedIncomeBarChart({
    Key? key,
    required this.dataMap,
    required this.labelType,
  }) : super(key: key);

  @override
  State<PaginatedIncomeBarChart> createState() =>
      _PaginatedIncomeBarChartState();
}

class _PaginatedIncomeBarChartState extends State<PaginatedIncomeBarChart> {
  static const int pageSize = 7;
  int startIndex = 0;

  @override
  Widget build(BuildContext context) {
    final keys = widget.dataMap.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // sort descending: newest first

    final totalPoints = keys.length;

    if (totalPoints == 0) return const Center(child: Text('No data'));

    // Clamp page index
    if (startIndex > totalPoints - pageSize) {
      startIndex = (totalPoints - pageSize).clamp(0, totalPoints);
    }
    if (startIndex < 0) startIndex = 0;

    final windowKeys = keys.sublist(
      startIndex,
      (startIndex + pageSize).clamp(0, totalPoints),
    );
    final windowValues = windowKeys.map((k) => widget.dataMap[k]!).toList();

    final maxValue = windowValues.reduce((a, b) => a > b ? a : b);
    final yInterval = _calculateYInterval(maxValue);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxValue + (maxValue * 0.2), // Add top space
                      minY: 0,
                      gridData: FlGridData(show: false),
                      barTouchData: BarTouchData(
                        enabled: false,
                      ), // disable tooltips
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: yInterval,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(0),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index < 0 || index >= windowKeys.length) {
                                return const SizedBox();
                              }
                              final key = windowKeys[index];
                              String label = widget.labelType == 'day'
                                  ? DateFormat(
                                      'MM/dd',
                                    ).format(DateTime.parse(key))
                                  : key;

                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Transform.rotate(
                                  angle:
                                      -3.14159 / 4, // -45° for better spacing
                                  child: Text(
                                    label,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      barGroups: List.generate(windowKeys.length, (i) {
                        final value = windowValues[i];
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: value,
                              color: Colors.green,
                              width: 18,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 250),
                  ),

                  // Overlay vertical labels above bars
                  IgnorePointer(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double spacing =
                            constraints.maxWidth / (windowKeys.length + 1);
                        double chartHeight = constraints.maxHeight;

                        return Stack(
                          children: List.generate(windowValues.length, (i) {
                            final value = windowValues[i];

                            // Calculate the normalized height of the bar
                            final normalizedHeight =
                                (value / maxValue) * (chartHeight - 30);

                            return Positioned(
                              left: spacing * (i + 1.47) - spacing / 2,
                              bottom: 90,
                              child: Transform.rotate(
                                angle: -3.14159 / 2, // -90° vertical
                                child: Text(
                                  '₹${value.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    shadows: [
                                      Shadow(
                                        color: Colors.white,
                                        blurRadius: 3, // Softness of shadow
                                        offset: Offset(
                                          0,
                                          0,
                                        ), // Shadow directly around the text
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Pagination Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: startIndex > 0
                      ? () => setState(() {
                          startIndex -= pageSize;
                          if (startIndex < 0) startIndex = 0;
                        })
                      : null,
                  child: const Icon(Icons.arrow_left),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: (startIndex + pageSize) < totalPoints
                      ? () => setState(() {
                          startIndex += pageSize;
                          if (startIndex > totalPoints - pageSize) {
                            startIndex = totalPoints - pageSize;
                          }
                        })
                      : null,
                  child: const Icon(Icons.arrow_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateYInterval(double max) {
    if (max <= 5) return 1;
    return (max / 4).ceilToDouble();
  }
}
