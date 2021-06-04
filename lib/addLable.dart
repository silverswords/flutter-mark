import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import './lable.dart';

class AddLable extends StatelessWidget {
  AddLable(this.id, {Key key}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    var _labal = '';
    final _formKey = GlobalKey<FormState>();

    return GestureDetector(
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(_labal)));
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
        child: Lable("添加"));
  }
}
