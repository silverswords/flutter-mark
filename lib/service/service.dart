import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Future<String> _deleteTag(int id) async {
//   var url = Uri.parse('https://sakura.cn.utools.club/api/v1/tag/delete');
//   var response = await http.post(
//     url,
//     body: jsonEncode(<String, dynamic>{
//       'id': id,
//     }),
//   );

//   if (response.statusCode != 200) {
//     return "删除失败";
//   }

//   return "删除成功";
// }

Future<String> insertMark(String url) async {
  var uri = Uri.parse("https://sakura.cn.utools.club/api/v1/mark/insert");
  var response = await http.post(
    uri,
    body: jsonEncode(<String, dynamic>{
      "url": "https://api.microlink.io?url=" + url,
      "baseUrl": url
    }),
  );

  if (response.statusCode != 200) {
    return "分享失败";
  }

  return "分享成功";
}

void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

Future<dynamic> getMarks() async {
  var url = Uri.parse('https://sakura.cn.utools.club/api/v1/mark/list');
  var response = await http.get(url);

  var data = jsonDecode(response.body);
  var list = data['marks'];

  return list;
}
