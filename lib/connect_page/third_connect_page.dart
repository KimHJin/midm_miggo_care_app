import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:miggo_care/connect_page/forth_connect_page.dart';

import '../bluetooth/ble_device.dart';


class ThirdConnectPage extends StatefulWidget {
  const ThirdConnectPage({Key? key, required this.bleDevice}) : super(key: key);

  final BleDevice bleDevice;

  @override
  State<ThirdConnectPage> createState() => _ThirdConnectPageState();
}

class _ThirdConnectPageState extends State<ThirdConnectPage> {

  late final BleDevice bleDevice;

  BluetoothDevice? _device;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bleDevice = widget.bleDevice;
    bleDevice.bleStartScan();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bleDevice.bleStopScan();
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20.0,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('제품을 선택하여 주세요.', style: TextStyle(fontSize: 20.0),),
                SizedBox(width: 10.0,),
                SizedBox(width: 20.0, height: 20.0, child: CircularProgressIndicator()),
              ],
            ),
            const SizedBox(height: 10.0,),
            const Divider(thickness: 1,),
            StreamBuilder<List<ScanResult>>(
              stream: bleDevice.getFlutterBlue.scanResults,
              initialData: [],
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  var index = snapshot.data!.indexWhere((r) => r.device.name == "Bluetooth BP");
                  if(index == -1) {
                    _device = null;
                  } else {
                    _device = snapshot.data!.elementAt(index).device;
                  }
                  if(_device != null) {
                    return ListTile(
                      /*leading: const CircleAvatar(
                        backgroundColor: Colors.cyan,
                        child: Icon(Icons.bluetooth, color: Colors.white,),
                      ),*/
                      leading: Image.asset('assets/Device.png'),
                      title: const Text('Miggo Care 장비'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForthConnectPage(bleDevice: bleDevice, device: _device!)),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
