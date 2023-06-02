import 'package:flutter/material.dart';

class DateBanner extends StatelessWidget {
  const DateBanner({Key? key, required this.dateStr, required this.onPressedLeft, required this.onPressedRight}) : super(key: key);

  final String dateStr;
  final Function() onPressedLeft;
  final Function() onPressedRight;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: onPressedLeft,
          ),
          const SizedBox(width: 10.0,),
          Text(dateStr, style: const TextStyle(fontSize: 20.0),),
          const SizedBox(width: 10.0,),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: onPressedRight,
          ),
        ],
      ),
    );
  }
}
