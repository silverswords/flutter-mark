import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  CommentPage(this.id, {Key key});
  final int id;
  @override
  State<StatefulWidget> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String inputValue;
  List<Comment> comments = List.empty(growable: true);
  final TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    comments = [Comment(content: "干得好"), Comment(content: "真不错")];
    inputValue = '';
  }

  List<Widget> buildList() {
    List<Widget> result = List.empty(growable: true);
    for (var comment in comments) {
      result.add(buildComment(comment));
    }

    return result;
  }

  Widget buildComment(Comment c) {
    return ListTile(title: Text(c.content));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
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
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 100,
                margin: EdgeInsets.fromLTRB(0, 20, 20, 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff339BF7)),
                  ),
                  onPressed: () {},
                  child: Text('评论'),
                ),
              )
            ],
          ),
          ...buildList()
        ],
      ),
    );
  }
}

class Comment {
  int id;
  String content;
  String createTime;
  Comment({this.id, this.content, this.createTime});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      createTime: json['createTime'],
    );
  }
}
