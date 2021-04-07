import 'package:flutter/material.dart';
class ListWidget extends StatelessWidget {
  final String text ;
  final IconData icon ;
  final Function onPressed ;
  ListWidget({this.text,this.icon,this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
        color: Color(0xff4072AF),
      ),
      title: Text(text,
        style: TextStyle(color: Color(0xff4072AF),
            fontWeight: FontWeight.bold),
      ),
      onTap: onPressed,
    );
  }
}
