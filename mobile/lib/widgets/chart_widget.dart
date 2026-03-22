import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/sensor_reading.dart';

class ChartWidget extends StatelessWidget {
  final List<ChartPoint> history;

  const ChartWidget({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Sensor Trends (Last 60 Readings)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: history.isEmpty
                ? const Center(child: Text('Waiting for history...', style: TextStyle(color: Colors.white54)))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 0.25,
                        getDrawingHorizontalLine: (value) {
                          return const FlLine(color: Colors.white12, strokeWidth: 1);
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 0.25,
                            reservedSize: 35,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${(value * 100).toInt()}%',
                                style: const TextStyle(color: Colors.white54, fontSize: 10),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 60, // 60-point rolling window
                      minY: 0,
                      maxY: 1.0, // Normalized from 0.0 to 1.0
                      lineBarsData: [
                        _buildLineChartBarData(
                          history.map((e) => e.Mn).toList(),
                          Colors.blueAccent,
                        ),
                        _buildLineChartBarData(
                          history.map((e) => e.Vn).toList(),
                          Colors.orangeAccent,
                        ),
                        _buildLineChartBarData(
                          history.map((e) => e.Tn).toList(),
                          Colors.purpleAccent,
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Moisture', Colors.blueAccent),
              const SizedBox(width: 16),
              _buildLegendItem('Vibration', Colors.orangeAccent),
              const SizedBox(width: 16),
              _buildLegendItem('Tilt', Colors.purpleAccent),
            ],
          )
        ],
      ),
    );
  }

  LineChartBarData _buildLineChartBarData(List<double> dataPoints, Color color) {
    List<FlSpot> spots = [];
    // We plot from right to left, anchoring the newest data to the right side
    int startOffset = 60 - dataPoints.length;

    for (int i = 0; i < dataPoints.length; i++) {
      spots.add(FlSpot((startOffset + i).toDouble(), dataPoints[i]));
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}