import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import './lable.dart';
import './addLable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xffe8e8e4),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[
    0xffd8e2dc,
    0xffece4db,
    0xffffe5d9,
    0xffffd7ba,
    0xfffcd5ce,
    0xfffae1dd,
    0xffe8e8e4,
  ];

  Future<List<Mark>> marks;

  @override
  void initState() {
    super.initState();
    marks = _getMarks();
  }

  Future<List<Mark>> _getMarks() async {
    var url = Uri.parse('http://127.0.0.1:10001/api/v1/mark/list');
    var response = await http.get(url);

    var data = jsonDecode(response.body);
    var list = data['marks'];

    List<Mark> result = List.empty(growable: true);
    for (var item in list) {
      result.add(Mark.fromJson(item));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<List<Mark>>(
        future: _getMarks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
          } else {
            return CircularProgressIndicator();
          }

          var marks = snapshot.data as List<Mark>;
          // return Text("${snapshot.data}");
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: marks.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.blueAccent,
                elevation: 20.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                clipBehavior: Clip.antiAlias,
                semanticContainer: false,
                child: Container(
                  height: 80,
                  color: Color(colorCodes[index % colorCodes.length]),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        _launchURL(marks[index].url);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () {
                        _launchURL(marks[index].url);
                      },
                      child: Text(
                        marks[index].title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Lable('日报'),
                        Lable('Network'),
                        AddLable(marks[index].id),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          );
        },
      )),
    );
  }
}

class Mark {
  int id;
  String url;
  String title;

  Mark({this.id, this.url, this.title});

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(id: json['id'], url: json['url'], title: json['title']);
  }
}

void _launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

aaaaaaa