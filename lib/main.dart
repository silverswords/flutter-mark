import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<int> bottom = <int>[0];
  String title, content;

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('bottom-sliver-list');

    return Scaffold(
        appBar: AppBar(
          title: Text('title'),
        ),
        body: ListTile(
          title: Text('title'),
          subtitle: Text(
            'hello',
            maxLines: 1,
          ),
        ));
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("内容详情"),
      ),
      body: Center(child: Text('内容详情')),
    );
  }
}


// CustomScrollView(
//         center: centerKey,
//         slivers: <Widget>[
//           SliverList(
//             key: centerKey,
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 return Container(
//                     alignment: Alignment.center,
//                     color: Colors.blue[200 + bottom[index] % 4 * 100],
//                     height: 100 + bottom[index] % 4 * 20.0,
//                     child: GestureDetector(
//                         child: Column(
//                           children: [
//                             Text(title),
//                             Text(content),
//                           ]
//                           ),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SecondRoute()),
//                           );
//                         })
//                     // ElevatedButton(
//                     //     child: Text("哈哈"),
//                     //     onPressed: () {
//                     //       Navigator.push(
//                     //         context,
//                     //         MaterialPageRoute(
//                     //             builder: (context) => SecondRoute()),
//                     //       );
//                     //     }));
//                     );
//               },
//               childCount: bottom.length,
//             ),
//           ),
//         ],
//       ),

// Scaffold(
//       appBar: AppBar(
//         title: const Text('技术猫'),
//         leading: IconButton(
//           icon: const Icon(Icons.add),
//           onPressed: () {
//             setState(() {
//               bottom.add(bottom.length);
//             });
//           },
//         ),
//       ),
//       body: 
      
//     );