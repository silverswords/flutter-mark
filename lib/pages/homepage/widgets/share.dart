part of './widgets.dart';

class Share extends StatelessWidget {
  Share({Key key, this.inputValue, this.setState, this.refresh})
      : super(key: key);

  Function setState;
  Function refresh;
  String inputValue;

  final TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
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
                  setState(
                    () {
                      inputValue = val;
                    },
                  );
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
              onPressed: () {
                insertMark(inputValue).then(
                  (result) {
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
                  },
                );
              },
              child: Text('分享'),
            ),
          )
        ],
      ),
    );
  }
}
