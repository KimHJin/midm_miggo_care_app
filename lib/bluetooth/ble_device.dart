import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BleDevice {
  static const String _PREFS_KEY = 'bluetooth_device_id';

  final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;

  final List<int> commandTimeSync = [0xFD, 0xFD, 0xFA, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0A];
  final List<int> commandGetMemory = [0xFD, 0xFD, 0xFA, 0x07, 0x0D, 0x0A];
  final List<int> commandClearMemory = [0xFD, 0xFD, 0xFA, 0x60, 0x0D, 0x0A];

  StreamController<List<int>> dataStream = StreamController<List<int>>.broadcast();
  StreamController<List<int>> memoryStream = StreamController<List<int>>.broadcast();
  StreamController<BluetoothDevice> deviceStream = StreamController<BluetoothDevice>();
  StreamController<BluetoothDeviceState> stateStream = StreamController<BluetoothDeviceState>.broadcast();

  BluetoothDevice? _device;

  BluetoothCharacteristic? rxChar;
  BluetoothCharacteristic? txChar;

  FlutterBluePlus get getFlutterBlue => _flutterBlue;
  String get bleDeviceName => _device!.name;
  String get bleDeviceMacAddress => _device!.id.id;
  BluetoothDevice? get getDevice => _device;
  set setDevice(BluetoothDevice device) => _device = device;


  Future<void> saveDevice(BluetoothDevice device) async {
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

// Retrieve BluetoothDevice object from Map
  Future<BluetoothDevice?> loadDevice() async {
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


  bleStartScan() {
   _flutterBlue.startScan(timeout: null);
  }

  bleStopScan() {
    _flutterBlue.stopScan();
  }

  bleConnect(BuildContext context) {
    _device!.connect(autoConnect: true).timeout(const Duration(seconds: 5), onTimeout: () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Connect Timeout'),
          action: SnackBarAction(label: 'UNDO', onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,),
        )
      );
      _device!.disconnect();
    }).then((value) {
      bleDiscovery();
      deviceStream.add(_device!);
      saveDevice(_device!);
    });
  }

  Future<void> bleDisconnect() async {
    await _device!.disconnect();
  }

  bleFindDevice(List<ScanResult> s) {
    var index = s.indexWhere((r) => r.device.name == "Bluetooth BP");
    if(index == -1) {
      _device = null;
    } else {
      bleStopScan();
      _device = s.elementAt(index).device;
    }
  }

  bleDiscovery() {
    _device!.discoverServices().then((s) {
      for(BluetoothService service in s) {
        for(BluetoothCharacteristic c in service.characteristics) {
          if(c.uuid == Guid("0000fff1-0000-1000-8000-00805f9b34fb")) {
            rxChar = c;
            bleSetNotify(rxChar!);
          }
          if(c.uuid == Guid("0000fff2-0000-1000-8000-00805f9b34fb")) {
            txChar = c;
            bleTimeSync();
          }
        }
      }
    });
  }

  bleSetNotify(BluetoothCharacteristic c) async {
    //print('------------------- set notify');
    await c.setNotifyValue(true);
    c.value.listen((value) {
      List<int> massage = value;
        if(massage.isNotEmpty) {
          if(massage[0] == 0xFD && massage[1] == 0xFD && massage.length >= 3) {
            if (massage[2] == 0xFB) { // 압력값
              List<int> data = List<int>.filled(3, 0);
              data[0] = massage[2];
              data[1] = massage[3];
              data[2] = massage[4];
              dataStream.add(data);
            } else if (massage[2] == 0xFC) { // 측정결과 값
              List<int> data = List<int>.filled(4, 0);
              data[0] = massage[2];
              data[1] = massage[3];
              data[2] = massage[4];
              data[3] = massage[5];
              dataStream.add(data);
            } else if (massage[2] == 0xFD) { // 에러
              List<int> data = List<int>.filled(2, 0);
              data[0] = massage[2];
              data[1] = massage[3];
              dataStream.add(data);
            } else if (massage[2] == 0xFE || massage[2] == 0xFF) { // 메모리
              List<int> data = List<int>.filled(11, 0);
              data[0] = massage[2];
              data[1] = massage[3];
              data[2] = massage[4];
              data[3] = massage[5];
              data[4] = massage[6];
              data[5] = massage[7];
              data[6] = massage[8];
              data[7] = massage[9];
              data[8] = massage[10];
              data[9] = massage[11];
              data[10] = massage[12];
              memoryStream.add(data);
            }
          }
      }
    });
  }

  bleTimeSync() async {
    DateTime now;
    now = DateTime.now();
    int year = now.year - 2000;
    int month = now.month;
    int day = now.day;
    int hour = now.hour;
    int minute = now.minute;
    int second = now.second;

    commandTimeSync[4] = year;
    commandTimeSync[5] = month;
    commandTimeSync[6] = day;
    commandTimeSync[7] = hour;
    commandTimeSync[8] = minute;
    commandTimeSync[9] = second;

    await txChar?.write(commandTimeSync, withoutResponse: true).then((value) {
    });

  }

  getMemory() async {
    await txChar?.write(commandGetMemory, withoutResponse: true).then((value) {
    });
  }

  Future<void> clearMemory() async {
    await txChar?.write(commandClearMemory, withoutResponse: true).then((value) {
    });
  }

}
