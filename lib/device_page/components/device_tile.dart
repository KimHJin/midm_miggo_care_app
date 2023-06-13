import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key? key, required this.title, required this.icon, required this.backgroundColor, required this.onTap}) : super(key: key);

  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150.0,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1.0,
                blurRadius: 5.0,
                offset: const Offset(4,4),
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 35.0, color: Colors.white,),
              const SizedBox(height: 10.0,),
              Text(title, style: const TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),),
              const SizedBox(height: 15.0,),
            ],
          ),
        ),
      ),
    );
  }
}
