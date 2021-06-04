import 'dart:convert';
import 'dart:io';

void main() async {
  var resp = await post("http://61ce0e379174.ngrok.io/api/v1/mark/insert");
  print(resp);
}

Future<String> post(String url) async {
  var URL = Uri.parse(url);
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(URL);

  Map jsonMap = {'url': '1'};
  request.add(utf8.encode(json.encode(jsonMap)));

  HttpClientResponse response = await request.close();

  String responseBody = await response.transform(utf8.decoder).join();

  return responseBody;
}
