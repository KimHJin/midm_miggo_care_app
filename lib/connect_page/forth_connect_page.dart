import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:miggo_care/bluetooth/ble_device.dart';
import 'package:miggo_care/home_page/home_page.dart';

import 'components/rounded_button.dart';


class ForthConnectPage extends StatefulWidget {
  const ForthConnectPage({Key? key, required this.bleDevice, required this.device}) : super(key: key);
  final BluetoothDevice? device;
  final BleDevice bleDevice;

  @override
  State<ForthConnectPage> createState() => _ForthConnectPageState();
}

class _ForthConnectPageState extends State<ForthConnectPage> {

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

      Future.delayed(const Duration(milliseconds: 500), () async{
        await _bleDevice.bleDisconnect().then((value) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) => UserSelectPage(bleDevice: _bleDevice,)),
                  (route) => false
          );
        });
      });

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
        ],
      ),
    );
  }
}


class UserSelectPage extends StatefulWidget {
  const UserSelectPage({Key? key, required this.bleDevice}) : super(key: key);

  final BleDevice bleDevice;

  @override
  State<UserSelectPage> createState() => _UserSelectPageState();
}

class _UserSelectPageState extends State<UserSelectPage> {

  late final BleDevice bleDevice;
  bool isUser1 = true;
  bool isUser2 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bleDevice = widget.bleDevice;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromRGBO(59, 130, 197, 1.0),),
        title: const Text("사용자 설정", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0,),
          const Text('제품의 개인번호를 지정하여 주세요.', style: TextStyle(fontSize: 20.0),),
          SizedBox(height: size.height*0.1,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: isUser1? Image.asset('assets/user1_select.png') : Image.asset('assets/user1_nomal.png'),
                iconSize: 60,
                onPressed: () {
                  setState(() {
                    isUser1 = true;
                    isUser2 = false;
                  });
                },
              ),
              const SizedBox(width: 10.0,),
              IconButton(
                icon: isUser2? Image.asset('assets/user2_select.png') : Image.asset('assets/user2_nomal.png'),
                iconSize: 60,
                onPressed: () {
                  setState(() {
                    isUser1 = false;
                    isUser2 = true;
                  });
                },
              )

            ],
          ),
          const Spacer(),
          RoundedButton(
            text: '등록 완료',
            color: const Color.fromRGBO(59, 130, 197, 1.0),
            textColor: Colors.white,
            press: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (BuildContext context) => const HomePage()),
                      (route) => false
              );
            }
          ),
          const SizedBox(height: 10.0,),
        ],
      ),
    );
  }
}

