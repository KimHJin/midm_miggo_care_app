import 'package:flutter/material.dart';

class MyDevicePage extends StatefulWidget {
  const MyDevicePage({Key? key}) : super(key: key);

  @override
  State<MyDevicePage> createState() => _MyDevicePageState();
}

class _MyDevicePageState extends State<MyDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("내 기기", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        child: Text('혈압계'),
      ),
    );
  }
}
