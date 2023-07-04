import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({Key? key, required this.title, required this.onPressed}) : super(key: key);

  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 80.0,
      width: size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
          border: Border.all(width: 0.5, color: Colors.grey),
          /*
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.0,
              blurRadius: 5.0,
              offset: const Offset(4,4),
            )
          ]*/
      ),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),),
              const Spacer(),
              IconButton(
                splashColor: Colors.blue,
                onPressed: onPressed,
                icon: const Icon(Icons.arrow_forward_ios)
              ),
            ],
          )
      ),
    );
  }
}
