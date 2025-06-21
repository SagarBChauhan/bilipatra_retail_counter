import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TestPrint.dart';

class PrintScreen extends StatefulWidget {
  final dynamic user;
  final List<dynamic> products;

  const PrintScreen({super.key, required this.user, required this.products});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final String _lastDeviceKey = "last_selected_printer";

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  // Load bonded devices and match previously selected device if available
  Future<void> _initBluetooth() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Searching for devices...';
    });

    try {
      if (await bluetooth.isOn ?? false) {
        final devices = await bluetooth.getBondedDevices();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final lastAddress = prefs.getString(_lastDeviceKey);

        BluetoothDevice? matchedDevice;
        try {
          matchedDevice = devices.firstWhere((d) => d.address == lastAddress);
        } catch (_) {
          matchedDevice = null;
        }

        setState(() {
          _devices = devices;
          _selectedDevice = matchedDevice;
          _statusMessage = devices.isNotEmpty
              ? 'Select a device to print'
              : 'No paired Bluetooth printers found.';
        });
      } else {
        setState(() {
          _statusMessage = 'Bluetooth is off. Please enable it.';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error fetching devices: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Save selected printer to SharedPreferences
  Future<void> _saveSelectedDevice(BluetoothDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDeviceKey, device.address!);
  }

  // Connect and print invoice
  Future<void> _connectAndPrint() async {
    if (_selectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a printer.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (!(await bluetooth.isConnected ?? false)) {
        await bluetooth.connect(_selectedDevice!);
      }

      await _saveSelectedDevice(_selectedDevice!);

      final printer = TestPrint();
      await printer.printInvoice(widget.user, widget.products);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Printing started.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Print failed: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thermal Printer"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Bluetooth Printer",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _devices.isEmpty
                ? Text(_statusMessage)
                : DropdownButton<BluetoothDevice>(
              isExpanded: true,
              value: _selectedDevice,
              hint: const Text("Select a printer"),
              items: _devices.map((device) {
                return DropdownMenuItem(
                  value: device,
                  child: Text(device.name ?? "Unnamed Device"),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedDevice = val;
                });
                if (val != null) _saveSelectedDevice(val);
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _connectAndPrint,
                icon: const Icon(Icons.print),
                label: const Text("Print Invoice"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
