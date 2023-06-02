import 'package:flutter/material.dart';


class MenuBarDrawer extends StatelessWidget {
  final String user;

  const MenuBarDrawer({
    super.key,
    this.user = "사용자",
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(39, 153, 250, 1.0),
      child: ListView(
        children: [
          SizedBox(
            height: 125.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(189, 224, 254, 1),
              ),
              child: Row(
                children: [
                  SizedBox(width: 10.0,),
                  Icon(Icons.account_circle, color: Colors.blue, size: 60.0,),
                  SizedBox(width: 10.0,),
                  Text(user, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('마이페이지', style: TextStyle(color: Colors.white),),
            leading: const Icon(Icons.account_circle, color: Colors.white,),
            onTap: (){},
          ),
          ListTile(
            title: const Text('알림 설정', style: TextStyle(color: Colors.white),),
            leading: const Icon(Icons.alarm, color: Colors.white,),
            onTap: (){},
          ),
          ListTile(
            title: const Text('로그아웃', style: TextStyle(color: Colors.white),),
            leading: const Icon(Icons.logout, color: Colors.white,),
            onTap: (){},
          ),
          ListTile(
            title: const Text('회원탈퇴', style: TextStyle(color: Colors.white),),
            leading: const Icon(Icons.account_circle, color: Colors.white,),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}

