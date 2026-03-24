import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bluetooth_provider.dart';
import '../providers/sensor_provider.dart';
import '../widgets/sensor_card.dart';
import '../widgets/risk_banner.dart';
import '../widgets/ml_prediction_card.dart';
import '../widgets/chart_widget.dart';
import '../widgets/connection_modal.dart';
import '../services/database_helper.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
  // Add this listener bridge!
      final btProvider = Provider.of<BluetoothProvider>(context, listen: false);
      final sensorProvider = Provider.of<SensorProvider>(context, listen: false);

      // Listen to the raw data stream from the HC-05 and feed it to our UI state
      btProvider.readingStream.listen((reading) {
        sensorProvider.updateReading(reading);
      });
    return Scaffold(
      appBar: AppBar(
        title: const Text('TerraGuard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
        // <-- ADD THIS EXPORT BUTTON -->
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.white70),
                    tooltip: 'Export CSV',
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generating CSV...')),
                      );
                      final result = await DatabaseHelper.instance.exportToCSV();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result), duration: const Duration(seconds: 4)),
                        );
                      }
                    },
                  ),
          // Connection Status Badge
          Consumer<BluetoothProvider>(
            builder: (context, btProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: btProvider.state == DeviceConnectionState.connected
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: btProvider.state == DeviceConnectionState.connected
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          btProvider.state == DeviceConnectionState.connected
                              ? Icons.bluetooth_connected
                              : Icons.bluetooth_disabled,
                          size: 16,
                          color: btProvider.state == DeviceConnectionState.connected
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          btProvider.state == DeviceConnectionState.connected
                              ? 'Connected'
                              : 'Offline',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: btProvider.state == DeviceConnectionState.connected
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<SensorProvider>(
                  builder: (context, sensorProv, child) {
                    final reading = sensorProv.currentReading;
                    final prediction = sensorProv.mlPrediction;

                    // If no data, show the waiting state
                    if (reading == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100.0),
                          child: Text(
                            "Awaiting Bluetooth Data...",
                            style: TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Risk Level Banner
                        RiskBanner(level: reading.level),
                        const SizedBox(height: 16),

                        // 2. Sensor Cards (Mn, Tn, Vn)
                        Row(
                          children: [
                            Expanded(
                              child: SensorCard(
                                title: 'Moisture',
                                rawValue: reading.moistureRaw.toStringAsFixed(0),
                                normalizedValue: reading.Mn,
                                color: Colors.blueAccent,
                                icon: Icons.water_drop,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SensorCard(
                                title: 'Vibration',
                                rawValue: reading.vibrationRaw.toStringAsFixed(0),
                                normalizedValue: reading.Vn,
                                color: Colors.orangeAccent,
                                icon: Icons.vibration,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SensorCard(
                                title: 'Tilt',
                                rawValue: '${reading.tilt.toStringAsFixed(1)}°',
                                normalizedValue: reading.Tn,
                                color: Colors.purpleAccent,
                                icon: Icons.screen_rotation,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(flex: 1, child: Container()),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // 3. AI Risk Prediction Panel (Only show if ML prediction exists)
                        if (prediction != null)
                          MlPredictionCard(prediction: prediction),

                        const SizedBox(height: 16),

                        // 4. Real-time Charts
                         if (sensorProv.chartHistory.isNotEmpty)
                         ChartWidget(history: sensorProv.chartHistory),

                         // A little extra padding at the bottom so the Floating Action Button doesn't cover the chart
                         const SizedBox(height: 80),
                      ],
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                // Open the Bluetooth Connection Modal
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ConnectionModal(),
                );
              },
              child: const Icon(Icons.bluetooth_searching, color: Colors.white),
            ),
    );
  }
}