import 'package:flutter/material.dart';

class MyCustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final bool autofocus;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final Function validator;

  MyCustomTextField({
    this.controller,
    this.autofocus = false,
    this.keyboardType,
    @required this.hintText,
    this.obscureText = false,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      autofocus: autofocus,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 20.0,),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0)
        )
      )
    );
  }
}
