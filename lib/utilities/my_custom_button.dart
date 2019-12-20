import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {

  final String text;
  final Function onPressed;

  MyCustomButton({
    this.text,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 10.0),
      child: RaisedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            fontSize: 20.0
          ),
        ),
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
      ),
    );
  }
}
