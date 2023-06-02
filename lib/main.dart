import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:miggo_care/bluetooth/ble_device.dart';
import 'package:miggo_care/graph_page/graph_page.dart';

import 'package:miggo_care/welcome_page/welcom_page.dart';
import 'home_page/home_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  BleDevice bleDevice = BleDevice();
  BluetoothDevice? device;
  bool isDevice = false;

  sleep(const Duration(seconds: 1));

  await bleDevice.loadDevice().then((dev) {
    if(dev == null) {
      isDevice = false;
      device = null;
    } else {
      isDevice = true;
      bleDevice.setDevice = dev;
    }
  });

  runApp(MyApp(bleDevice: bleDevice, isDevice: isDevice,));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.bleDevice, required this.isDevice}) : super(key: key);

  final BleDevice bleDevice;
  final bool isDevice;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final BleDevice bleDevice;
  bool isDevice = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bleDevice = widget.bleDevice;
    isDevice = widget.isDevice;
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Miggo Care App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: (isDevice == false) ? WelcomePage(bleDevice: bleDevice,) : HomePage(bleDevice: bleDevice,),
    );
  }
}

