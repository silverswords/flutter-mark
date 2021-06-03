import 'package:flutter/material.dart';
import 'package:mark/lable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blueGrey[600],
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
  final List<int> colorCodes = <int>[100, 200, 300, 400, 500];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.separated(
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
                height: 100,
                color: Colors.blueGrey[colorCodes[index % colorCodes.length]],
                child: ListTile(
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                            fit: BoxFit.fill)),
                  ),
                  title: Text("Web3极客日报 #525 | Rebase Network | Rebase社区"),
                  subtitle: Lable('一枚有态度的程序员'),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }
}
