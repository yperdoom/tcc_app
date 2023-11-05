import 'dart:convert';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

Future<dynamic> getManagers() async {
  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  };
  Uri url = Uri.parse('$baseUrl/user/managers');

  http.Response response = await http.get(
    url,
    headers: headers,
  );
  var body = await jsonDecode(response.body);

  if (body['success'] == true) {
    return body['body']['managers'];
  }
  return [];
}
