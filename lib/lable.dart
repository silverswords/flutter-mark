import 'package:flutter/material.dart';

class Lable extends StatelessWidget {
  String name = "";

  Lable(this.name);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Center(
        child: Text(
          "#" + name,
        ),
      ),
    );
  }
}

// AnimatedButton(
//                         text: 'Warning Dialog',
//                         color: Colors.orange,
//                         pressEvent: () {
//                           AwesomeDialog(
//                               context: context,
//                               dialogType: DialogType.WARNING,
//                               headerAnimationLoop: false,
//                               animType: AnimType.TOPSLIDE,
//                               showCloseIcon: true,
//                               closeIcon: Icon(Icons.close_fullscreen_outlined),
//                               title: 'Warning',
//                               desc: 'Dialog description here',
//                               btnCancelOnPress: () {},
//                               btnOkOnPress: () {})
//                             ..show();
//                         },
//                       ),