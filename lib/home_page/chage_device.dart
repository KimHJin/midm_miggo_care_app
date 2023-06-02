import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../bluetooth/ble_device.dart';
import 'components/rounded_button.dart';
import 'home_page.dart';

class ChangeDevicePage extends StatelessWidget {
  const ChangeDevicePage({Key? key, required this.bleDevice}) : super(key: key);

  final BleDevice bleDevice;

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
            const SizedBox(height: 20.0,),
            const Text('새로 등록할 기기를 다음과 같이 조작해 주세요.', style: TextStyle(fontSize: 18.0),),
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
                  MaterialPageRoute(builder: (context) => NewDeviceSearchPage(bleDevice: bleDevice,)),
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



class NewDeviceSearchPage extends StatefulWidget {
  const NewDeviceSearchPage({Key? key, required this.bleDevice}) : super(key: key);

  final BleDevice bleDevice;

  @override
  State<NewDeviceSearchPage> createState() => _NewDeviceSearchPage();
}

class _NewDeviceSearchPage extends State<NewDeviceSearchPage> {

  late final BleDevice bleDevice;

  BluetoothDevice? _device;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bleDevice = widget.bleDevice;
    bleDevice.bleDisconnect().then((value) {
      bleDevice.bleStartScan();
    });
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
                      leading: Image.asset('assets/Device.png'),
                      title: const Text('Miggo Care 장비'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewDeviceConnectPage(bleDevice: bleDevice, device: _device!)),
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


class NewDeviceConnectPage extends StatefulWidget {
  const NewDeviceConnectPage({Key? key, required this.bleDevice, required this.device}) : super(key: key);
  final BluetoothDevice? device;
  final BleDevice bleDevice;

  @override
  State<NewDeviceConnectPage> createState() => _NewDeviceConnectPage();
}

class _NewDeviceConnectPage extends State<NewDeviceConnectPage> {

  late final BleDevice _bleDevice;
  late final BluetoothDevice? _device;

  bool isConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bleDevice = widget.bleDevice;
    _device = widget.device;

    _device!.connect(autoConnect: false).timeout(const Duration(seconds: 5), onTimeout: () {
      isConnected = false;
      Navigator.pop(context);

    }).then((value) {
      _bleDevice.saveDevice(_device!);
      _bleDevice.setDevice = _device!;
      setState(() { isConnected = true; });
    });
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
        iconTheme: const IconThemeData(color: Color.fromRGBO(59, 130, 197, 1.0),),
        title: const Text("블루투스 연결", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0,),
          Text((isConnected == false) ? '연결중입니다. 잠시만 기다려주세요..' : '연결이 완료되었습니다!', style: const TextStyle(fontSize: 20.0),),
          Expanded(
              child: Center(
                  child: (isConnected == false) ?
                  const SizedBox(height:80, width:80, child: CircularProgressIndicator())
                      : const Icon(Icons.check_box_outlined, color: Colors.blue, size: 90.0,)
              )
          ),
          RoundedButton(
            text: '등록 완료',
            color: const Color.fromRGBO(59, 130, 197, 1.0),
            textColor: Colors.white,
            press: (isConnected == false) ?
            null
                : () async {
              await _bleDevice.bleDisconnect().then((value) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(bleDevice: _bleDevice,)),
                        (route) => false
                );
              });
            },
          ),
          const SizedBox(height: 10.0,),
        ],
      ),
    );
  }
}

