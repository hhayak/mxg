import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mxg/models/weight_entry.dart';
import 'package:mxg/screens/home_tab.dart';
import 'package:mxg/widgets/flat_card.dart';
import 'package:mxg/widgets/text_title.dart';
import 'package:provider/provider.dart';

class ProgressTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<List<WeightEntry>>(
      builder: (context, snapshot, child) {
        if (snapshot.isEmpty || snapshot.length < 3) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NoDataAvailable(),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextTitle(text: 'Your Progress'),
                FlatCard.filled(
                  height: 400,
                  color: Colors.indigo.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ProgressChart(
                      entries: snapshot,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class ProgressChart extends StatelessWidget {
  final List<WeightEntry> entries;

  const ProgressChart({Key? key, required this.entries}) : super(key: key);

  LineChartData buildChart(List<WeightEntry> snapshot) {
    var minY = double.maxFinite;
    var maxY = double.minPositive;
    // Prepare Spots.
    var spots = snapshot
        .map((e) {
          var date = e.weight;
          if (minY > date) {
            minY = e.weight.toDouble();
          }
          if (maxY < date) {
            maxY = e.weight.toDouble();
          }
          return FlSpot(
            e.date.millisecondsSinceEpoch.toDouble(),
            e.weight.toDouble(),
          );
        })
        .toList()
        .reversed
        .toList();

    // Build the line.
    final line = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter:(FlSpot spot, double xPercentage, LineChartBarData bar, int index) => FlDotCirclePainter(
          radius: 3,
          color: Colors.teal,
          strokeColor: Colors.teal,
        )
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return LineChartData(
      //backgroundColor: Colors.deepPurple.shade700,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 70,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 20,
          getTitles: (value) {
            final DateTime date =
                DateTime.fromMillisecondsSinceEpoch(value.toInt());
            return DateFormat.yMd().format(date);
          },
          rotateAngle: 90,
          interval: (line.spots.last.x - line.spots.first.x) / 7,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) => value.toInt().toString(),
          margin: 20,
          interval: 10,
          //reservedSize: 15,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: line.spots.first.x,
      maxX: line.spots.last.x,
      maxY: maxY + 20,
      minY: minY - 20,
      lineBarsData: [line],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(buildChart(entries));
  }
}
