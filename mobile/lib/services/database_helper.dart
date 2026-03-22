import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/sensor_reading.dart';

class DatabaseHelper {
  // Singleton pattern to ensure we only have one database connection
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('terraguard_readings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Creating a structured table to hold our time-series data
    await db.execute('''
      CREATE TABLE readings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        moistureRaw REAL NOT NULL,
        Mn REAL NOT NULL,
        tilt REAL NOT NULL,
        Tn REAL NOT NULL,
        vibrationRaw REAL NOT NULL,
        Vn REAL NOT NULL,
        riskScore REAL NOT NULL,
        riskLevel TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertReading(SensorReading reading) async {
    final db = await instance.database;

    await db.insert('readings', {
      'timestamp': reading.timestamp.toIso8601String(),
      'moistureRaw': reading.moistureRaw,
      'Mn': reading.Mn,
      'tilt': reading.tilt,
      'Tn': reading.Tn,
      'vibrationRaw': reading.vibrationRaw,
      'Vn': reading.Vn,
      'riskScore': reading.R,
      'riskLevel': reading.level.name,
    });
  }

  // Retrieve all data for the CSV Export
  Future<List<Map<String, dynamic>>> fetchAllReadings() async {
    final db = await instance.database;
    return await db.query('readings', orderBy: 'timestamp DESC');
  }

  // Export functionality to fulfill your dashboard requirements
  Future<String> exportToCSV() async {
    try {
      final data = await fetchAllReadings();
      if (data.isEmpty) return "No data to export.";

      String csvData = "Timestamp,Moisture(Raw),Moisture(N),Tilt(°),Tilt(N),Vibration(Raw),Vibration(N),Risk Score,Risk Level\n";

      for (var row in data) {
        csvData += "${row['timestamp']},${row['moistureRaw']},${row['Mn']},${row['tilt']},${row['Tn']},${row['vibrationRaw']},${row['Vn']},${row['riskScore']},${row['riskLevel']}\n";
      }

      // Save to device Documents folder
      final directory = await getApplicationDocumentsDirectory();
      final path = join(directory.path, "TerraGuard_Export_${DateTime.now().millisecondsSinceEpoch}.csv");
      final file = File(path);
      await file.writeAsString(csvData);

      return "Saved to: $path";
    } catch (e) {
      return "Error exporting data: $e";
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}