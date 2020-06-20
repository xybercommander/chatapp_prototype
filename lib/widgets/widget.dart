import 'package:flutter/material.dart';

/* The app bar for all the pages */

Widget appBarMain() {
  return AppBar(
    backgroundColor: Color.fromRGBO(20, 82, 146, 1),    
    title: Image.asset("assets/images/chatapp .jpg", height: 90,),
  );
}

/* The text field input widget */

InputDecoration textFieldInputDecoration(String hintText) {
 return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white38
    ),
      focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white)
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white)
    )
 );
}

/* Text Field style (Color only) */

TextStyle simpleStyle() {
  return TextStyle(
    color: Colors.white,    
  );
}

/* Medium Text Styler */
TextStyle mediumStyle(Color customColor) {
  return TextStyle(
    color: customColor,
    fontSize: 17    
  );
}