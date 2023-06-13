import 'package:flutter/material.dart';
import 'package:miggo_care/device_page/components/device_tile.dart';

class MyDevicePage extends StatefulWidget {
  const MyDevicePage({Key? key}) : super(key: key);

  @override
  State<MyDevicePage> createState() => _MyDevicePageState();
}

class _MyDevicePageState extends State<MyDevicePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("내 기기", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 10.0,),
              Text('연결할 디바이스를 선택하세요.'),
              const SizedBox(height: 10.0,),
              DeviceTile(title: '혈압계', backgroundColor: const Color.fromRGBO(59, 130, 197, 0.7), icon: Icons.monitor_heart_outlined, onTap: (){},),
              const SizedBox(height: 10.0,),
              DeviceTile(title: '혈당계', backgroundColor: const Color.fromRGBO(234, 97, 142, 0.7), icon: Icons.monitor_heart_outlined, onTap: (){},),
              const SizedBox(height: 10.0,),
              DeviceTile(title: '체온계', backgroundColor: const Color.fromRGBO(38, 175, 79, 0.7), icon: Icons.monitor_heart_outlined, onTap: (){},),
            ],
          ),
        ),
      )
    );
  }
}
