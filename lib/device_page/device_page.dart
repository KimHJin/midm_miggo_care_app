import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:miggo_care/bluetooth/ble_device.dart';
import 'package:miggo_care/device_page/components/device_tile.dart';
import 'package:miggo_care/device_page/connect_device_page.dart';

class MyDevicePage extends StatefulWidget {
  const MyDevicePage({Key? key}) : super(key: key);

  @override
  State<MyDevicePage> createState() => _MyDevicePageState();
}

class _MyDevicePageState extends State<MyDevicePage> {

  String? deviceName;
  String? macAddress;
  BluetoothDevice? device;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    device = BleDevice.device;
    if(device != null) {
      deviceName = 'MSM-1000';
      macAddress = device!.id.id;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
              const Text('연결할 장비를 선택하세요.', style: TextStyle(fontSize: 18.0),),
              const SizedBox(height: 30.0,),
              DeviceTile(
                title: '혈압계',
                deviceName: deviceName,
                macAddress: macAddress,
                backgroundColor: const Color.fromRGBO(59, 130, 197, 0.7),
                icon: Icons.monitor_heart_outlined,
                onTap: () {
                  if(device != null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('현재 연결된 장비가 있습니다.'),
                            content: const Text('연결을 해제하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  BleDevice.clearDevice();
                                  BleDevice.device = null;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ConnectDevicePage()),
                                  );
                                },
                                child: Text('해제'),
                              ),
                            ],
                          );
                        }
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ConnectDevicePage()),
                    );
                  }
/*
                  */
                },
              ),
              const SizedBox(height: 15.0,),
              DeviceTile(
                title: '혈당계',
                deviceName: null,
                macAddress: null,
                backgroundColor: const Color.fromRGBO(234, 97, 142, 0.7),
                icon: Icons.monitor_heart_outlined,
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('서비스 준비중입니다.'),
                        content: const Text('추후 업데이터할 예정입니다.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    }
                  );
                },
              ),
              const SizedBox(height: 15.0,),
              DeviceTile(
                title: '체온계',
                deviceName: null,
                macAddress: null,
                backgroundColor: const Color.fromRGBO(38, 175, 79, 0.7),
                icon: Icons.monitor_heart_outlined,
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('서비스 준비중입니다.'),
                          content: const Text('추후 업데이터할 예정입니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      }
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
