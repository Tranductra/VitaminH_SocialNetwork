import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color boderColor;
  final String text;
  final Color textColor;
  const FollowButton({
    super.key,
    required this.function,
    required this.backgroundColor,
    required this.boderColor,
    required this.text,
    required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: boderColor),
            borderRadius: BorderRadius.circular(5)
          ),
          alignment: Alignment.center,
          width: 200,
          height: 27,
            child: Text(text, style: TextStyle(
                color: textColor,
            fontWeight: FontWeight.bold),),

        ),
      ),
    );
  }
}
