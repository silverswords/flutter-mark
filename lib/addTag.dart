import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

typedef void VoidCallback();

class AddTag extends StatelessWidget {
  AddTag(this.id, this.index, {Key key, this.refresh}) : super(key: key);
  final int id;
  final int index;
  final void Function() refresh;

  @override
  Widget build(BuildContext context) {
    var _labal = '';
    final _formKey = GlobalKey<FormState>();
    AwesomeDialog dialog;
    return ItemTags(
      elevation: 2,
      key: Key(index.toString()),
      index: index, // required
      title: "add",
      active: false,
      textColor: Color(0xff000000),
      textActiveColor: Color(0xff000000),
      color: Color(0xffFFFFFF),
      activeColor: Color(0xffFFFFFF),
      textStyle: TextStyle(
        fontSize: 12,
      ),
      icon: ItemTagsIcon(
        icon: Icons.add,
      ),
      onPressed: (item) => {
        dialog = AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.INFO,
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
                      color: Colors.blueGrey.withAlpha(40),
                      child: TextFormField(
                        onSaved: (value) {
                          _labal = value;
                        },
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
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
                      color: Colors.blue,
                      pressEvent: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _insertTag(id, _labal).then((result) {
                            Fluttertoast.showToast(
                                msg: result,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            refresh();
                            dialog.dissmiss();
                            return true;
                          });
                        }
                      },
                      text: 'Submit',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AnimatedButton(
                        color: Color(0xffEE5750),
                        text: 'Close',
                        pressEvent: () {
                          dialog.dissmiss();
                        })
                  ],
                ),
              )
              // child:
              ),
        )..show()
      },
    );
  }
}

_insertTag(int markID, String tagName) async {
  var url = Uri.parse('https://sakura.cn.utools.club/api/v1/tag/insert');
  var response = await http.post(
    url,
    body: jsonEncode(<String, dynamic>{
      'mark_id': markID,
      'tag_name': tagName,
    }),
  );

  if (response.statusCode != 200) {
    return "添加失败";
  }

  return "添加成功";
}
