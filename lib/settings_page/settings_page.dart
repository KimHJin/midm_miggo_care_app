import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:miggo_care/settings_page/components/settings_tile.dart';
import 'package:miggo_care/settings_page/sub_page/alarm.dart';

import 'sub_page/set_my_profile.dart';
import 'sub_page/term.dart';

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
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SetMyProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 10.0,),
              SettingTile(
                title: '알림 설정',
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AlarmPage()),
                  );
                },
              ),
              const SizedBox(height: 10.0,),
              SettingTile(
                title: '개인정보 보호 및 약관',
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsPage()),
                  );
                },
              ),
              const SizedBox(height: 10.0,),
              SettingTile(
                title: '미꼬케어 평가',
                onPressed: () async {
                  /*
                  final InAppReview inAppReview = InAppReview.instance;

                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  } else {
                    // In-App Review가 지원되지 않는 플랫폼 또는 버전일 때 처리할 코드를 추가합니다.
                    // 예: 앱 스토어로 리디렉션하거나 대체 리뷰 요청 방법을 제공합니다.
                  }*/
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
