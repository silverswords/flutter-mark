import 'package:http/http.dart' as http;

void main() {
  get();
}

void get() async {
  var url = Uri.parse('https://www.yuque.com');
  var response = await http.get(url);
  print(response.statusCode);
  print(response.body);
}
