import 'package:flutter/material.dart';
import 'package:miggo_care/settings_page/components/settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("설정", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SettingTile(
                title: '내 정보 설정',
                onPressed: (){},
              ),
              const SizedBox(height: 5.0,),
              SettingTile(
                title: '계정 및 보안',
                onPressed: (){},
              ),
              const SizedBox(height: 5.0,),
              SettingTile(
                title: '알림 설정',
                onPressed: (){},
              ),
              const SizedBox(height: 5.0,),
              SettingTile(
                title: '개인정보 보호 및 약관',
                onPressed: (){},
              ),
              const SizedBox(height: 5.0,),
              SettingTile(
                title: '도움말',
                onPressed: (){},
              ),
              const SizedBox(height: 5.0,),
              SettingTile(
                title: '미꼬케어 평가',
                onPressed: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
