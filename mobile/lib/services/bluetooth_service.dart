import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/sensor_reading.dart';
import 'serial_parser_service.dart';

class BluetoothService {
  BluetoothConnection? _connection;
  StreamSubscription<Uint8List>? _streamSubscription;

  // We use a StreamController to broadcast parsed readings to the rest of your app
  final StreamController<SensorReading> _readingStreamController = StreamController<SensorReading>.broadcast();
  Stream<SensorReading> get readingStream => _readingStreamController.stream;

  // 1. Get paired devices (from phone's Bluetooth settings)
  Future<List<BluetoothDevice>> getPairedDevices() async {
    try {
      return await FlutterBluetoothSerial.instance.getBondedDevices();
    } catch (e) {
      print("Error getting paired devices: $e");
      return [];
    }
  }

  // 2. Connect to the HC-05
  Future<bool> connectToDevice(String address) async {
    try {
      _connection = await BluetoothConnection.toAddress(address);
      print('Connected to device: $address');

      String buffer = '';

      // 3. Listen to the raw data stream
      _streamSubscription = _connection!.input!.listen((Uint8List data) {
        // Convert incoming bytes to an ASCII string chunk
        String chunk = String.fromCharCodes(data);
        buffer += chunk;

        // Check if we have received a complete line (ending in newline)
        if (buffer.contains('\n')) {
          List<String> lines = buffer.split('\n');

          // Process all complete lines
          for (int i = 0; i < lines.length - 1; i++) {
            String line = lines[i].trim();
            if (line.isNotEmpty) {
              // Send the line to our Parser
              SensorReading? reading = SerialParserService.parseFrame(line);
              if (reading != null) {
                // Broadcast the valid reading to the app
                _readingStreamController.add(reading);
              }
            }
          }
          // Keep the incomplete chunk in the buffer for the next incoming data
          buffer = lines.last;
        }
      });

      return true;
    } catch (e) {
      print('Connection failed: $e');
      return false;
    }
  }

  // 4. Disconnect gracefully
  Future<void> disconnect() async {
    await _streamSubscription?.cancel();
    await _connection?.close();
    _connection = null;
  }

  void dispose() {
    _readingStreamController.close();
    disconnect();
  }
}