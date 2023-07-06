import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:miggo_care/_BloodPressure/BloodPressure.dart';
import 'package:miggo_care/bluetooth/ble_device.dart';
import 'package:miggo_care/main.dart';

import 'components/rounded_button.dart';

class DataSyncPage extends StatefulWidget {
  const DataSyncPage({Key? key}) : super(key: key);

  @override
  State<DataSyncPage> createState() => _DataSyncPageState();
}

class _DataSyncPageState extends State<DataSyncPage> {

  FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;
  BluetoothDevice? bluetoothDevice;

  BluetoothCharacteristic? rxChar;
  BluetoothCharacteristic? txChar;

  StreamSubscription<List<int>>? notifySubscription;

  List<BloodPressure> list = [];
  List<List<int>> memoryData = [];

  bool isConnecting = false;
  bool isDone = false;

  final List<int> commandReadMemory = [0xFD, 0xFD, 0xFA, 0x07, 0x0D, 0x0A];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(isConnecting == false) {
      bluetoothDevice = BleDevice.device;
      if (BleDevice.device == null) {
        showAlertDialog(context, '연결된 기기가 없습니다.', '미꼬케어 혈압계를 연결해주세요.');
      } else {
        BleDevice.device!.connect().timeout(const Duration(seconds: 5), onTimeout: () {
          showAlertDialog(context, '장비를 연결할 수 없습니다.', '블루투스 연결을 위해 장비를 켜주세요.');
        }).then((value) {
          BleDevice.device!.discoverServices().then((s) async {
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
            isConnecting = true;
            await setNotify(rxChar!);
            await txChar?.write(commandReadMemory, withoutResponse: true);
          });
        });
      }
    }
  }

  @override
  void dispose() {
    notifySubscription!.cancel();
    disconnect().then((_) {
      // TODO: implement dispose
      super.dispose();
    });
  }

  Future<void> disconnect() async {
    await BleDevice.device!.disconnect();
  }

  Future<void> setNotify(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);

    notifySubscription = characteristic.value.listen((value) {
      if(value.isNotEmpty) {
        if(value[0] == 0xFD && value[1] == 0xFD && (value[2] == 0xFE || value[2] == 0xFF)) {
          if(value.length >= 11) {
            List<int> array = value.sublist(3, 12 + 1);
            if(value[4] != 0x00) {
              memoryData.add(array);
            }
            if(value[2] == 0xFF || value[3] == 0x02) {
              for (var element in memoryData) {
                DateTime date = DateTime(
                  element[4]*100 + element[5],
                  element[6],
                  element[7],
                  element[8],
                  element[9]
                );
                BloodPressure bp = BloodPressure(systolic: element[1], diastolic: element[2], pulse: element[3], measuredAt: date);
                BloodPressure.insertBloodPressure(bp);
              }

              BloodPressure.getBloodPressures().then((value) {
                list = value;
                for(var element in list) {
                  print(element);
                }
              });
              setState(() {
                isDone = true;
              });
            }
          }
        } else {

        }
      }
    });
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        await disconnect();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color.fromRGBO(59, 130, 197, 1.0),),
          title: const Text("데이터 가져오기", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
        ),
        body: Center(
          child: isDone? Column(
            children: [
              SizedBox(height: size.height * 0.25,),
              const SizedBox(child: Icon(Icons.check_circle_outline, color: Colors.blue, size: 100,)),
              const Spacer(),
              const Text('기다려주셔서 감사합니다.', style: TextStyle(fontSize: 18.0),),
              const SizedBox(height: 20.0,),
              const Text('혈압 데이터를 성공적으로 가지고 왔습니다.', style: TextStyle(fontSize: 18.0)),
              const SizedBox(height: 50.0,),
              RoundedButton(
                text: '완료',
                backgroundColor: const Color.fromRGBO(59, 130, 197, 1.0),
                textColor: Colors.white,
                press: () {
                  disconnect().then((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Main(pageIndex: 0,)),
                    );
                  });
                },
              ),
              const SizedBox(height: 10.0,),
            ],
          ) :
          Column(
            children: [
              SizedBox(height: size.height * 0.25,),
              const SizedBox(width: 80, height: 80, child: CircularProgressIndicator()),
              const Spacer(),
              const Text('잠시만 기다려주세요.', style: TextStyle(fontSize: 18.0),),
              const SizedBox(height: 20.0,),
              const Text('혈압 데이터를 가지고 오는 중입니다.', style: TextStyle(fontSize: 18.0)),
              const SizedBox(height: 50.0,),
              RoundedButton(
                text: '취소',
                backgroundColor: const Color.fromRGBO(59, 130, 197, 1.0),
                textColor: Colors.white,
                press: () {
                  disconnect().then((_) {
                    Navigator.pop(context);
                  });
                },
              ),
              const SizedBox(height: 10.0,),
            ],
          ),
        ),
      ),
    );
  }
}
