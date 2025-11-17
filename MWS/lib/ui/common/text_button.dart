import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.name,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final String name;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black, // Replaces `primary`
        textStyle: const TextStyle(
          fontSize: 14.0,
          fontFamily: "Roboto",
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(name, textAlign: TextAlign.center),
    );
  }
}
