import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'addTag.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter',
      theme: ThemeData(
        primaryColor: Color(0xff7EC87C),
      ),
      home: MyHomePage(title: 'flutter'),
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
    0xffFCFED3,
    0xffF5FBB7,
    0xffF0F9B4,
    0xffE3F5AB,
    0xffC6E89A,
    0xffC5E799,
    0xffA9DB8C,
    0xffC6E89A,
    0xffF5FBB7,
  ];
  final List<int> tagsColorCodes = <int>[
    0xff40bf80,
    0xff39ac73,
    0xff339966,
    0xff2d8659,
    0xff26734d,
  ];

  List<Mark> marks = List.empty();
  String inputValue;

  final TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _getMarks();
    inputValue = '';
  }

  void refresh() {
    _getMarks();
  }

  _getMarks() async {
    var url = Uri.parse('https://sakura.cn.utools.club/api/v1/mark/list');
    var response = await http.get(url);

    var data = jsonDecode(response.body);
    var list = data['marks'];

    List<Mark> result = List.empty(growable: true);
    for (var item in list) {
      result.add(Mark.fromJson(item));
    }

    setState(() => {this.marks = result});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFEFFE3),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          inputValue = val;
                        });
                      },
                    ))),
            Container(
              height: 40,
              width: 100,
              margin: EdgeInsets.fromLTRB(0, 10, 20, 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff7EC87C)),
                ),
                onPressed: () {
                  _insertMark(inputValue).then((result) {
                    Fluttertoast.showToast(
                        msg: result,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    _controller.clear();
                    refresh();
                  });
                },
                child: Text('分享'),
              ),
            )
          ],
        ),
        Expanded(
            child: Center(
                child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: marks.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.blueAccent,
              elevation: 20.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              clipBehavior: Clip.antiAlias,
              semanticContainer: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                              image: marks[index].icon.startsWith("http")
                                  ? () {
                                      ImageProvider<Object> result;
                                      try {
                                        result =
                                            NetworkImage(marks[index].icon);
                                      } catch (Expection) {
                                        result = AssetImage(
                                            "assets/images/default.png");
                                      }
                                      return result;
                                    }()
                                  : AssetImage("assets/images/default.png"),
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
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Tags(
                          itemCount: marks[index].tags.length + 1,
                          itemBuilder: (int tagIndex) {
                            if (tagIndex >= marks[index].tags.length) {
                              return AddTag(
                                marks[index].id,
                                tagIndex,
                                refresh: refresh,
                              );
                            }

                            final item = marks[index].tags[tagIndex];

                            return ItemTags(
                              key: Key(tagIndex.toString()),
                              index: tagIndex,
                              title: item.name,
                              textStyle: TextStyle(
                                fontSize: 12,
                              ),
                              activeColor: Color(tagsColorCodes[
                                  tagIndex % tagsColorCodes.length]),
                              combine: ItemTagsCombine.withTextBefore,
                              removeButton: ItemTagsRemoveButton(
                                color: Color.fromRGBO(50, 50, 50, 0.5),
                                onRemoved: () {
                                  _deleteTag(item.relationID).then((result) {
                                    refresh();
                                    Fluttertoast.showToast(
                                        msg: result,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    return true;
                                  });
                                  // refresh();

                                  return true;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        )))
      ]),
    );
  }
}

class Mark {
  int id;
  String url;
  String title;
  String icon;
  List<TagRelation> tags;

  Mark({this.id, this.url, this.title, this.icon, this.tags});

  factory Mark.fromJson(Map<String, dynamic> json) {
    List<TagRelation> tags = List.empty(growable: true);
    if (json['tags'] != null) {
      for (var tag in json['tags']) {
        tags.add(TagRelation.fromJson(tag));
      }
    }

    return Mark(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      icon: json['icon'],
      tags: tags,
    );
  }
}

class TagRelation {
  TagRelation({this.name, this.relationID});
  int relationID;
  String name;

  factory TagRelation.fromJson(Map<String, dynamic> json) {
    return TagRelation(
      name: json['name'],
      relationID: json['id'],
    );
  }
}

void _launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

Future<String> _deleteTag(int id) async {
  var url = Uri.parse('https://sakura.cn.utools.club/api/v1/tag/delete');
  var response = await http.post(
    url,
    body: jsonEncode(<String, dynamic>{
      'id': id,
    }),
  );

  if (response.statusCode != 200) {
    return "删除失败";
  }

  return "删除成功";
}

void onShare() {
  // var resp = await post("http://61ce0e379174.ngrok.io/api/v1/mark/insert");

  Fluttertoast.showToast(
    msg: 'hello',
  );
}

Future<String> _insertMark(String url) async {
  var uri = Uri.parse("https://sakura.cn.utools.club/api/v1/mark/insert");
  var response = await http.post(
    uri,
    body: jsonEncode(<String, dynamic>{"url": url}),
  );

  if (response.statusCode != 200) {
    return "添加失败";
  }

  return "添加成功";
}
