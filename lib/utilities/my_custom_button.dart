import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {

  final String text;
  final Function onPressed;
  final double fontSize;

  MyCustomButton({
    this.text,
    this.onPressed,
    this.fontSize
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 10.0),
      child: RaisedButton(
        color: Color(0xff006680),
        elevation: 6.0,
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xffffdd55),
            fontSize: fontSize
          ),
        ),
        padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
      ),
    );
  }
}
