part of './widgets.dart';

insertTag(int markID, String tagName) async {
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

addTag(BuildContext context, int index, int id, Function() refresh) {
  var _labal = '';
  final _formKey = GlobalKey<FormState>();
  AwesomeDialog dialog;
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
                    insertTag(id, _labal).then((result) {
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
                      Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
                  })
            ],
          ),
        )
        // child:
        ),
  )..show();
}
