import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function()? press;
  final Color backgroundColor, textColor;
  const RoundedButton({
    super.key,
    required this.text,
    required this.press,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: TextButton(
          style: TextButton.styleFrom(backgroundColor: backgroundColor, padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40), disabledBackgroundColor: Colors.grey),
          onPressed: press,
          child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 17.0),),
        ),
      ),
    );
  }
}
