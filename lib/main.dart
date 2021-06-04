import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import './lable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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

  var _labal = '';
  final _formKey = GlobalKey<FormState>();
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
        future: marks,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // if (snapshot.connectionState == ConnectionState.done) {
          //   if (snapshot.hasError) {
          //     return Text("Error: ${snapshot.error}");
          //   }
          // } else {
          //   return CircularProgressIndicator();
          // }

          // return Text("${snapshot.data}");
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length * 10,
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
                        _launchURL('https://flutter.dev');
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
                        _launchURL('https://flutter.dev');
                      },
                      child: Text(
                        "Google Removes Diversity Head over Shocking ‘If I Were a Jew’ Blog",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Lable('日报'),
                        Lable('Network'),
                        GestureDetector(
                            onTap: () {
                              AwesomeDialog dialog;
                              dialog = AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.QUESTION,
                                keyboardAware: true,
                                body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Material(
                                            elevation: 0,
                                            color:
                                                Colors.blueGrey.withAlpha(40),
                                            child: TextFormField(
                                              onSaved: (value) {
                                                _labal = value;
                                              },
                                              autofocus: true,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              // maxLengthEnforced: true,
                                              minLines: 2,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelText: 'Description',
                                                prefixIcon: Icon(
                                                  Icons.text_fields,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AnimatedButton(
                                            color: Colors.orange,
                                            pressEvent: () {
                                              dialog.dissmiss();

                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(_labal)));
                                              }
                                            },
                                            text: 'Submit',
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AnimatedButton(
                                              text: 'Close',
                                              pressEvent: () {
                                                dialog.dissmiss();
                                              })
                                        ],
                                      ),
                                    )
                                    // child:
                                    ),
                              )..show();
                            },
                            child: Lable("添加")),
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
