import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/bluetooth_provider.dart';
import 'screens/dashboard_screen.dart';
import 'services/notification_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized before loading ML weights
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the ML Engine right when the app starts
  final sensorProvider = SensorProvider();
  await sensorProvider.initializeML();
  await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sensorProvider),
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
      ],
      child: const TerraGuardApp(),
    ),
  );
}

class TerraGuardApp extends StatelessWidget {
  const TerraGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TerraGuard',
      debugShowCheckedModeBanner: false,
      // Setting up the dark theme based on your roadmap
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.blueAccent,
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.tealAccent,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}