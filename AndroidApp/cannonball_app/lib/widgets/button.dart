import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;

  Button({
    this.buttonName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      child: new Text(buttonName),
      onPressed: onPressed,
    );
  }
}