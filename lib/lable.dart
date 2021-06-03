import 'package:flutter/material.dart';

class Lable extends StatelessWidget {
  String name = "123";

  Lable(this.name);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(name),
    );
  }
}
