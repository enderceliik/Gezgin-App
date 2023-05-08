import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String textForTextButton;
  final Color textColorForTextButton;
  const FollowButton({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColorForTextButton,
    required this.textForTextButton,
    this.function,  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          top: 14.0,
        ),
        child: TextButton(
          onPressed: function,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            child: Text(
              textForTextButton,
              style: TextStyle(
                color: textColorForTextButton,
                fontWeight: FontWeight.bold,
              ),
            ),
            width: 150.0, //mediaQuery
            height: 32.0,
          ),
        ));
  }
}
