import 'package:flutter/material.dart';

class SectionBanner extends StatelessWidget {
  final String title;
  final Widget child;
  const SectionBanner({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width:size.width, height: 65,
      color: const Color.fromRGBO(59, 130, 197, 1.0),
      child: Row (
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10,),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: child,
            ),
          ),
          const SizedBox(width: 10,),
        ],
      ),
    );
  }
}
