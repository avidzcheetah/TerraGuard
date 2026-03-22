import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/sensor_reading.dart';
import '../services/bluetooth_service.dart';

enum DeviceConnectionState { disconnected, scanning, connecting, connected, error }

class BluetoothProvider extends ChangeNotifier {
  final BluetoothService _bluetoothService = BluetoothService();

  DeviceConnectionState _state = DeviceConnectionState.disconnected;
  String _deviceName = '';
  String _errorMessage = '';
  List<BluetoothDevice> _pairedDevices = [];

  DeviceConnectionState get state => _state;
  String get deviceName => _deviceName;
  String get errorMessage => _errorMessage;
  List<BluetoothDevice> get pairedDevices => _pairedDevices;

  // Expose the raw stream so SensorProvider can listen to it later
  Stream<SensorReading> get readingStream => _bluetoothService.readingStream;

  Future<void> scanForDevices() async {
    _state = DeviceConnectionState.scanning;
    notifyListeners();

    try {
      _pairedDevices = await _bluetoothService.getPairedDevices();
      _state = DeviceConnectionState.disconnected; // Done scanning
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to get devices: $e';
      _state = DeviceConnectionState.error;
      notifyListeners();
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    _state = DeviceConnectionState.connecting;
    _deviceName = device.name ?? 'HC-05';
    notifyListeners();

    bool success = await _bluetoothService.connectToDevice(device.address);

    if (success) {
      _state = DeviceConnectionState.connected;
    } else {
      _errorMessage = 'Could not connect to $_deviceName';
      _state = DeviceConnectionState.error;
    }
    notifyListeners();
  }

  Future<void> disconnect() async {
    await _bluetoothService.disconnect();
    _state = DeviceConnectionState.disconnected;
    _deviceName = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }
}