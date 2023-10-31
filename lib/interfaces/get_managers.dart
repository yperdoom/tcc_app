import 'dart:convert';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

Future<List<Object>> getManagers() async {
  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  };
  Uri url = Uri.parse('$baseUrl/user/managers');

  print(url);

  http.Response response = await http.get(
    url,
    headers: headers,
  );
  var body = await jsonDecode(response.body);

  print(body);

  return [];
}
