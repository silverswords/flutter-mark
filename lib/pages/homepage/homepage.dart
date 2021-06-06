import 'package:flutter/material.dart';

import './widgets/widgets.dart';
import '../../model/homepage.dart';
import '../../service/homepage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Mark> marks = List.empty();
  String inputValue;
  int TagIndex;

  final TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _refresh();
    inputValue = '';
    TagIndex = 0;
  }

  _refresh() async {
    var list = await getMarks();
    List<Mark> result = List.empty(growable: true);
    for (var item in list) {
      result.add(Mark.fromJson(item));
    }

    setState(() => {this.marks = result});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Share(
              inputValue: inputValue,
              setState: setState,
              refresh: _refresh,
            ),
            Expanded(
              child: Center(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                  itemCount: marks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomerCard(context, marks, index, _refresh);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
