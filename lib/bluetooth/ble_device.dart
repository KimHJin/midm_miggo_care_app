import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BleDevice {

  static BluetoothDevice? device;

  static Future<void> saveDevice(BluetoothDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceMap = {
      'name': device.name,
      'id': device.id.toString(),
      'type': device.type.toString(),
      'mtu': device.mtu.toString(),
      // add other properties as needed
    };
    await prefs.setString('deviceKey', jsonEncode(deviceMap)); // Save Map as String in SharedPreferences
  }

  static Future<BluetoothDevice?> loadDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceString = prefs.getString('deviceKey');
    if (deviceString != null) {
      final deviceMap = jsonDecode(deviceString);
      final device = BluetoothDevice.fromId(deviceMap['id']);
      // set other properties of the device object
      return device;
    } else {
      return null;
    }
  }

  static Future<void> clearDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('deviceKey');
  }
}
