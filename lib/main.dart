import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'addTag.dart';
import 'package:flutter_tags/flutter_tags.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HakerMake',
      theme: ThemeData(
        primaryColor: Color(0xffe8e8e4),
      ),
      home: MyHomePage(title: 'HakerMake'),
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
  final List<int> tagsColorCodes = <int>[
    // 0xfff94144,
    // 0xfff3722c,
    // 0xfff8961e,
    // 0xfff9844a,
    // 0xfff9c74f,
    0xff90be6d,
    0xff43aa8b,
    0xff4d908e,
    0xff577590,
    0xff277da1,
  ];
  List<Mark> marks = List.empty();

  @override
  void initState() {
    super.initState();
    _getMarks();
  }

  void refresh() {
    _getMarks();
  }

  _getMarks() async {
    var url = Uri.parse('https://dovics.cn.utools.club/api/v1/mark/list');
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView.separated(
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
              // height: 80,
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
                              onRemoved: () {
                                _deleteTag(item.relationID)
                                    .then(() => {refresh()});
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
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )),
    );
  }
}

class Mark {
  int id;
  String url;
  String title;
  List<TagRelation> tags;

  Mark({this.id, this.url, this.title, this.tags});

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

_deleteTag(int id) async {
  var url = Uri.parse('https://dovics.cn.utools.club/api/v1/tag/delete');
  var response = await http.post(
    url,
    body: jsonEncode(<String, dynamic>{
      'id': id,
    }),
  );

  if (response.statusCode != 200) {}
}
