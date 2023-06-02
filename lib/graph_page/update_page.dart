import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:miggo_care/BloodPressure/BloodPressure.dart';
import 'package:miggo_care/bluetooth/ble_device.dart';

import 'components/rounded_button.dart';


class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key, required this.bleDevice}) : super(key: key);

  final BleDevice bleDevice;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late final BleDevice bleDevice;

  List<List<int>>? memoryData;
  BloodPressure? bloodPressure;

  bool isConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bleDevice = widget.bleDevice;
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
        title: const Text("혈압 불러오기", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: StreamBuilder<BluetoothDeviceState>(
        stream: bleDevice.stateStream.stream,
        builder: (context, snapshot) {
          if(snapshot.data == BluetoothDeviceState.connected) {
            isConnected = true;
          } else {
            isConnected = false;
          }
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('제품 왼쪽 메모리 버튼을 눌러주세요.', style: TextStyle(fontSize: 18.0),),
                    StreamBuilder<List<int>>(
                      stream: bleDevice.memoryStream.stream,
                      builder: (context, snapshot) {
                        if(snapshot.hasData && snapshot.data!.isNotEmpty) {

                          if(snapshot.data![2] != 0) {
                            DateTime date = DateTime(
                                snapshot.data![5] * 100 + snapshot.data![6],
                                snapshot.data![7],
                                snapshot.data![8],
                                snapshot.data![9],
                                snapshot.data![10]
                            );

                            BloodPressure bp = BloodPressure(
                                systolic: snapshot.data![2],
                                diastolic: snapshot.data![3],
                                pulse: snapshot.data![4],
                                measuredAt: date
                            );

                            BloodPressure.insertBloodPressure(bp).then((value) {
                              //print(snapshot.data!);
                              //print(bp.toMap());
                            });
                          }

                          if(snapshot.data![0] == 0xFF && snapshot.data![1] == 2) {
                            //print('memory end');
                            bleDevice.clearMemory().then((value) {
                              Navigator.pop(context);
                            });
                          }
                          return const CircularProgressIndicator();

                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: size.height*0.07,),
                SizedBox(width: size.width*0.8, height: size.width*0.8, child: Image.asset('assets/memory.png')),
                const Spacer(),
                RoundedButton(
                  text: '불러오기',
                  color: const Color.fromRGBO(59, 130, 197, 1.0),
                  textColor: Colors.white,
                  press: isConnected ? (){bleDevice.getMemory();} : null,
                ),
                const SizedBox(height: 10.0,),
              ],
            ),
          );
        }
      )
    );
  }
}


