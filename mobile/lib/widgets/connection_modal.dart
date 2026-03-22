import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bluetooth_provider.dart';

class ConnectionModal extends StatefulWidget {
  const ConnectionModal({super.key});

  @override
  State<ConnectionModal> createState() => _ConnectionModalState();
}

class _ConnectionModalState extends State<ConnectionModal> {
  @override
  void initState() {
    super.initState();
    // Start scanning for devices the moment the modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BluetoothProvider>(context, listen: false).scanForDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Consumer<BluetoothProvider>(
        builder: (context, btProvider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Device Connection',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Before Connecting:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    SizedBox(height: 8),
                    Text('1. Power on HC-05 (Red LED should blink rapidly)'),
                    Text('2. Pair it in your Android Bluetooth Settings first (PIN: 1234)'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Status indicator
              if (btProvider.state == DeviceConnectionState.scanning)
                const Center(child: CircularProgressIndicator())
              else if (btProvider.errorMessage.isNotEmpty)
                Text(
                  btProvider.errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),

              // Device List
              if (btProvider.pairedDevices.isNotEmpty) ...[
                const Text('Paired Devices', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: btProvider.pairedDevices.length,
                    itemBuilder: (context, index) {
                      final device = btProvider.pairedDevices[index];
                      // Highlight the HC-05 if we spot it
                      final isHC05 = device.name?.toUpperCase().contains('HC-05') ?? false;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.bluetooth,
                          color: isHC05 ? Colors.blueAccent : Colors.white24,
                        ),
                        title: Text(
                          device.name ?? 'Unknown Device',
                          style: TextStyle(
                            color: isHC05 ? Colors.white : Colors.white54,
                            fontWeight: isHC05 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(device.address, style: const TextStyle(fontSize: 10, color: Colors.white38)),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btProvider.state == DeviceConnectionState.connecting
                                ? Colors.grey
                                : Colors.blueAccent,
                          ),
                          onPressed: btProvider.state == DeviceConnectionState.connecting
                              ? null
                              : () async {
                                  await btProvider.connectToDevice(device);
                                  if (btProvider.state == DeviceConnectionState.connected && mounted) {
                                    Navigator.pop(context); // Close modal on success
                                  }
                                },
                          child: btProvider.state == DeviceConnectionState.connecting && btProvider.deviceName == device.name
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Connect', style: TextStyle(color: Colors.white)),
                        ),
                      );
                    },
                  ),
                ),
              ] else if (btProvider.state != DeviceConnectionState.scanning) ...[
                const Center(
                  child: Text('No paired devices found.\nPlease pair the HC-05 in Android settings first.',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)),
                ),
              ],

              const SizedBox(height: 16),

              // Disconnect Button (Only shows if already connected)
              if (btProvider.state == DeviceConnectionState.connected)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    btProvider.disconnect();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.bluetooth_disabled, color: Colors.white),
                  label: const Text('Disconnect from Device', style: TextStyle(color: Colors.white)),
                ),
            ],
          );
        },
      ),
    );
  }
}