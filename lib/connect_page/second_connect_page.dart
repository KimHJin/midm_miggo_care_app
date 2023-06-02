import 'package:flutter/material.dart';
import 'package:miggo_care/connect_page/third_connect_page.dart';
import '../bluetooth/ble_device.dart';
import 'components/rounded_button.dart';

class SecondConnectPage extends StatelessWidget {
  const SecondConnectPage({Key? key, required this.bleDevice}) : super(key: key);

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
                    MaterialPageRoute(builder: (context) => ThirdConnectPage(bleDevice: bleDevice,)),
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
