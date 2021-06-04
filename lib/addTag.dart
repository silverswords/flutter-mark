import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:http/http.dart' as http;

class AddTag extends StatelessWidget {
  AddTag(this.id, this.index, {Key key, this.refresh}) : super(key: key);
  final int id;
  final int index;
  Function refresh;

  @override
  Widget build(BuildContext context) {
    var _labal = '';
    final _formKey = GlobalKey<FormState>();
    AwesomeDialog dialog;
    return ItemTags(
      key: Key(index.toString()),
      index: index, // required
      title: "add",
      activeColor: Color(0xff89b0ae),
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
                      color: Colors.orange,
                      pressEvent: () {
                        dialog.dissmiss();

                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _insertTag(id, _labal).then(() => {refresh()});
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
        )..show()
      },
    );
  }
}

_insertTag(int markID, String tagName) async {
  var url = Uri.parse('https://dovics.cn.utools.club/api/v1/tag/insert');
  var response = await http.post(
    url,
    body: jsonEncode(<String, dynamic>{
      'mark_id': markID,
      'tag_name': tagName,
    }),
  );

  if (response.statusCode != 200) {}
}

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
