part of './widgets.dart';

class AddTag extends StatelessWidget {
  AddTag({Key key, this.index, this.id, this.refresh}) : super(key: key);
  int index;
  int id;
  Function refresh;

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

  _addTag(BuildContext context, int index, int id, Function() refresh) async {
    int i = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('其他功能'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
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
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('增加标签'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  // 返回2
                  Navigator.pop(context, 2);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text(''),
                ),
              ),
            ],
          );
        });

    if (i != null) {
      print("选择了：${i == 1 ? "中文简体" : "美国英语"}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          _addTag(context, index, id, refresh);
        },
        icon: Image.asset('assets/images/morefunction.png'));
  }
}
