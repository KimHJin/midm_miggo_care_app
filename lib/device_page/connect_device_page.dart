import 'package:flutter/material.dart';
import 'package:miggo_care/bluetooth/ble_device.dart';
import 'package:miggo_care/device_page/components/rounded_button.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:miggo_care/main.dart';

class ConnectDevicePage extends StatefulWidget {
  const ConnectDevicePage({Key? key}) : super(key: key);

  @override
  State<ConnectDevicePage> createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("기기 연결", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20.0,),
            const Text('다음 안내에 따라 제품을 조작해 주세요.', style: TextStyle(fontSize: 20.0),),
            SizedBox(height: size.height*0.07,),
            SizedBox(width: size.width*0.8, height: size.width*0.8, child: Image.asset('assets/pairing.png')),
            const Spacer(),
            RoundedButton(
              text: '다음',
              color: const Color.fromRGBO(59, 130, 197, 1.0),
              textColor: Colors.white,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeviceSearchPage()),
                );
              },
            ),
            const SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }
}

class DeviceSearchPage extends StatefulWidget {
  const DeviceSearchPage({Key? key}) : super(key: key);

  @override
  State<DeviceSearchPage> createState() => _DeviceSearchPageState();
}

class _DeviceSearchPageState extends State<DeviceSearchPage> {
  FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  ScanResult? result;

  BluetoothCharacteristic? rxChar;
  BluetoothCharacteristic? txChar;

  final List<int> commandTimeSync = [0xFD, 0xFD, 0xFA, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x0A];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result = null;
    scan();
  }

  @override
  void dispose() {
    flutterBluePlus.stopScan();
    result = null;
    print('dispose');
    // TODO: implement dispose
    super.dispose();
  }

  scan() async {
    if(result == null) {
      scanResultList.clear();
      flutterBluePlus.startScan(timeout: null);
      flutterBluePlus.scanResults.listen((results) {
        scanResultList = results;
        var index = results.indexWhere((r) => (r.device.name == "MSM-1000" || r.device.name == "Bluetooth BP"));
        if (index == -1) {} else {
          result = results.elementAt(index);
          flutterBluePlus.stopScan();
          if(mounted) {
            setState(() {});
          }
        }
      });
    } else {
      flutterBluePlus.stopScan();
    }
  }

  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      //name = r.device.name;
      name = 'MSM-1000';
    } else if (r.advertisementData.localName.isNotEmpty) {
      name = r.advertisementData.localName;

    } else {
      name = 'N/A';
    }
    return Text(name);
  }

  /* BLE 아이콘 위젯 */
  Widget leading(ScanResult r) {
    return CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  /* 장치 아이템을 탭 했을때 호출 되는 함수 */
  void onTap(ScanResult r) {
    DateTime now = DateTime.now();
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

    // 단순히 이름만 출력
    print('${r.device.name}');
    r.device.connect(autoConnect: true).timeout(const Duration(seconds: 5), onTimeout: () {

    }).then((value) {
      BleDevice.saveDevice(r.device);
      BleDevice.device = r.device;
      Future.delayed(const Duration(milliseconds: 500), () async{
        r.device.discoverServices().then((s) async {
          for (BluetoothService service in s) {
            for (BluetoothCharacteristic c in service.characteristics) {
              if (c.uuid == Guid("0000fff1-0000-1000-8000-00805f9b34fb")) {
                rxChar = c;
              }
              if (c.uuid == Guid("0000fff2-0000-1000-8000-00805f9b34fb")) {
                txChar = c;
              }
            }
          }
          await txChar?.write(commandTimeSync, withoutResponse: true).then((value) async {
            await r.device.disconnect().then((value) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (BuildContext context) => const Main(pageIndex: 2,)),
                      (route) => false
              );
            });
          });
        });
      });
    });
  }

  /* 장치 아이템 위젯 */
  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromRGBO(59, 130, 197, 1.0),),
        title: const Text("블루투스 연결", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.25,),
            (result != null) ? listItem(result!):
            const SizedBox(width: 80, height: 80, child: CircularProgressIndicator()),
            const Spacer(),
            const Text('잠시만 기다려주세요.', style: TextStyle(fontSize: 18.0),),
            const SizedBox(height: 20.0,),
            const Text('미꼬케어 혈압계를 찾고 있습니다.', style: TextStyle(fontSize: 18.0)),
            const SizedBox(height: 50.0,),
            RoundedButton(
              text: '취소',
              color: const Color.fromRGBO(59, 130, 197, 1.0),
              textColor: Colors.white,
              press: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }
}

