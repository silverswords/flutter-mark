import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import './widgets/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter',
      theme: ThemeData(
        primaryColor: Colors.white,
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

  List<Mark> marks = List.empty();
  String inputValue;
  int TagIndex;

  final TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _getMarks();
    inputValue = '';
    TagIndex = 0;
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
      backgroundColor: Color(0xffE5E5E5),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
            SizedBox(height: 50),
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        // color: Color(0xffF1F2F7),
                        // height: 40,
                        margin: EdgeInsets.fromLTRB(15, 20, 20, 10),
                        child:
                            // textfield -
                            TextField(
                          controller: _controller,
                          cursorWidth: 2.0,
                          // scrollPadding: EdgeInsets.symmetric(vertical: -2),
                          decoration: InputDecoration(
                            fillColor: Color(0xffF1F2F7),
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xffF4F5F7),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xffF4F5F7),
                                width: 1,
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
                  margin: EdgeInsets.fromLTRB(0, 20, 20, 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xff339BF7)),
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
                    child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              itemCount: marks.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                  color: Color(0xffFFFFFF),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  semanticContainer: false,
                  child: Column(children: <Widget>[
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(marks[index].picture),
                        fit: BoxFit.cover,
                      )),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      // height: 240,
                      // color: Color(colorCodes[index % colorCodes.length]),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            _launchURL(marks[index].url);
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: marks[index].icon.startsWith("http")
                                        ? () {
                                            ImageProvider<Object> result;
                                            try {
                                              result = NetworkImage(
                                                  marks[index].icon);
                                            } catch (Expection) {
                                              result = AssetImage(
                                                  "assets/images/default.png");
                                            }
                                            return result;
                                          }()
                                        : AssetImage(
                                            "assets/images/default.png"),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () {
                            _launchURL(marks[index].url);
                          },
                          child: Text(
                            marks[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Column(children: <Widget>[
                            Text(
                              marks[index].sub_title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                                // height: 60,
                                child: Stack(
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Tags(
                                    itemCount: marks[index].tags.length,
                                    itemBuilder: (int tagIndex) {
                                      TagIndex = tagIndex;

                                      final item = marks[index].tags[tagIndex];

                                      return Container(
                                          height: 22,
                                          margin: EdgeInsets.only(top: 6),
                                          child: ItemTags(
                                            elevation: 2,
                                            border: Border.all(
                                                color: Color(0xffFFFFFF)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 0),
                                            key: Key(tagIndex.toString()),
                                            index: tagIndex,
                                            title: item.name,
                                            textStyle: TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 12,
                                            ),
                                            active: false,
                                            color: Color(0xffFFFFFF),
                                            textColor: Color(0xff000000),
                                            textActiveColor: Color(0xff000000),
                                            activeColor: Color(0xff607D8B),
                                            combine:
                                                ItemTagsCombine.withTextBefore,
                                          ));
                                    },
                                  )
                                ]),
                                // Stack(children: <Widget>[
                                Container(
                                  height: 32,
                                  width: 32,
                                  margin: EdgeInsets.fromLTRB(251, 0, 0, 0),
                                  child: AddTag(
                                      index: index,
                                      id: marks[index].id,
                                      refresh: refresh),
                                )
                              ],
                            )),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                );
              },
            )))
          ])),
    );
  }
}

class Mark {
  int id;
  String sub_title;
  String url;
  String title;
  String icon;
  String picture;
  List<TagRelation> tags;

  Mark(
      {this.id,
      this.url,
      this.title,
      this.sub_title,
      this.icon,
      this.picture,
      this.tags});

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
      sub_title: json['sub_title'],
      picture: json['picture'],
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
    body: jsonEncode(<String, dynamic>{
      "url": "https://api.microlink.io?url=" + url,
      "baseUrl": url
    }),
  );

  if (response.statusCode != 200) {
    return "添加失败";
  }

  return "添加成功";
}
