import 'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {
  final String text ;
  final Function onPressed ;
  final Color color ;
  RoundedButton({this.text,this.color,@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 100.0),
        child: Material(
          elevation: 5.0,
          color: color,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 350.0,
            height: 45.0 ,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0 ,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
  }
}