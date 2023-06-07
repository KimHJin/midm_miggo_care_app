import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:miggo_care/log_page/log_page.dart';

import '../bluetooth/ble_device.dart';
import 'chage_device.dart';
import 'components/menu_bar.dart';
import 'components/result_screen.dart';
import 'components/section_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.bleDevice,}) : super(key: key);

  final BleDevice bleDevice;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final BleDevice _bleDevice;
  BluetoothDevice? _device;

  bool isData = false;
  bool isError = false;

  String sysData = '00';
  String diaData = '00';
  String bpmData = '00';
  String year = '00';
  String month = '00';
  String day = '00';
  String hour = '00';
  String minute = '00';

  String error = '00';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bleDevice = widget.bleDevice;
    _device = _bleDevice.getDevice;

    _loadList().then((list) {
      sysData = (list.isEmpty) ? '00' : list[0];
      diaData = (list.isEmpty) ? '00' : list[1];
      bpmData = (list.isEmpty) ? '00' : list[2];
      year = (list.isEmpty) ? '00' : list[3];
      month = (list.isEmpty) ? '00' : list[4];
      day = (list.isEmpty) ? '00' : list[5];
      hour = (list.isEmpty) ? '00' : list[6];
      minute = (list.isEmpty) ? '00' : list[7];
    });

    _device!.connect(autoConnect: true).then((value) {
      setState(() {
        _bleDevice.bleDiscovery();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<List<String>> _loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> myList = prefs.getStringList('lastData') ?? [];
    return myList;
  }

  Future<void> _saveList(List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('lastData', list);
  }

  dataParsing(AsyncSnapshot<List<int>> snapshot) {
    if(snapshot.hasData && snapshot.data!.length > 1) {
      if(snapshot.data![0] == 0xFC) {
        sysData = snapshot.data![1].toString();
        diaData = snapshot.data![2].toString();
        bpmData = snapshot.data![3].toString();
        DateTime now = DateTime.now();
        year = now.year.toString();
        month = now.month.toString().padLeft(2,'0');
        day = now.day.toString().padLeft(2,'0');
        hour = now.hour.toString().padLeft(2,'0');
        minute = now.minute.toString().padLeft(2,'0');

        List<String> lastData = [];

        lastData.add(sysData);
        lastData.add(diaData);
        lastData.add(bpmData);
        lastData.add(year);
        lastData.add(month);
        lastData.add(day);
        lastData.add(hour);
        lastData.add(minute);

        _saveList(lastData);
        isData = false;
        isError = false;
      } else if(snapshot.data![0] == 0xFD) {
        isData = false;
        isError = true;
        if(snapshot.data![1] == 0x01) {
          error = 'E1';
        } else if(snapshot.data![1] == 0x02) {
          error = 'E2';
        } else if(snapshot.data![1] == 0x03) {
          error = 'E3';
        } else if(snapshot.data![1] == 0x04) {
          error = 'E4';
        } else {
          error = 'Err';
        }
      } else if(snapshot.data![0] == 0xFB) {
        isData = true;
        isError = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromRGBO(59, 130, 197, 1.0)),
        title: const Text("MIGGO CARE", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
        /*actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color.fromRGBO(59, 130, 197, 1.0),),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],*/
      ),
      //drawer: const MenuBarDrawer(user: "사용자",),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: StreamBuilder<List<int>>(
              stream: _bleDevice.dataStream.stream,
              builder: (context, snapshot) {
                dataParsing(snapshot);
                return Column(
                  children: [
                    SectionBanner(
                      title: "혈압",
                      child: (isData == true) ?
                      const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white,),)
                      : (isError == true) ? Text(error, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),)
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$year-$month-$day', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),),
                            Text('$hour:$minute', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),),
                          ],
                        ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(flex: 15, child: ResultText(title: "최고혈압", value: sysData, unit: "mmHg",),),
                                    const SizedBox(width: 5.0,),
                                    Expanded(flex: 13, child: ResultText(title: '맥박', value: bpmData, unit: "회/분",)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5.0,),
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(flex: 15, child: ResultText(title: "최저혈압", value: diaData, unit: "mmHg",),),
                                    const SizedBox(width: 5.0,),
                                    Expanded(
                                      flex: 13,
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const MyLogPage()),
                                          );
                                        },
                                        child: Container(
                                          color: const Color.fromRGBO(189, 224, 254, 1),
                                          child: const Center(
                                            child: Column(
                                              children: [
                                                SizedBox(height: 5.0,),
                                                Row(children: [SizedBox(width: 5.0,), Text('혈압노트', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(59, 130, 197, 1.0),),)],),
                                                Expanded(child: Icon(Icons.event_note, color: Color.fromRGBO(59, 130, 197, 1.0), size: 70.0,)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SectionBanner(
                  title: "기기",
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text('기기 변경', style: TextStyle(color: Colors.blue),),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangeDevicePage(bleDevice: _bleDevice,)),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ListTile(
                      leading: Image.asset('assets/miggo_care_app_icon.png'),
                      title: const Text('Miggo Care'),
                      subtitle: Text(_bleDevice.bleDeviceMacAddress),
                      trailing: TextButton(
                        onPressed: (){},
                        child: StreamBuilder<BluetoothDeviceState>(
                          stream: _bleDevice.getDevice!.state,
                          initialData: BluetoothDeviceState.disconnected,
                          builder: (context, snapshot) {
                            VoidCallback? onPressed;
                            String text;
                            switch(snapshot.data) {
                              case BluetoothDeviceState.connected :
                                _bleDevice.stateStream.add(BluetoothDeviceState.connected);
                                onPressed = (){_bleDevice.bleDisconnect();};
                                text = '연결됨';
                                break;
                              case BluetoothDeviceState.disconnected :
                                _bleDevice.stateStream.add(BluetoothDeviceState.disconnected);
                                onPressed = (){_bleDevice.bleConnect(context);};
                                text = '연결 끊어짐';
                                isData = false;
                                List<int> list = [];
                                _bleDevice.dataStream.add(list);
                                break;
                              default :
                                onPressed = null;
                                text = snapshot.data.toString().substring(21).toUpperCase();
                                break;
                            }
                            return TextButton(
                              //style: TextButton.styleFrom(backgroundColor: const Color.fromRGBO(59, 130, 197, 1.0)),
                              onPressed: (){},
                              child: Text(text, style: const TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0)),),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



