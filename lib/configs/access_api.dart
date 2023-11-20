import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/session.dart';
import 'package:http/http.dart' as http;

String baseUrl = Session.baseUrl;

Future<dynamic> accessApi(String method, String path, String query, Object body) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token').toString();

  Uri url = Uri.parse('$baseUrl/$path${query.isNotEmpty ? '?$query' : ''}');
  Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': token
  };

  print('url :: $url');

  http.Response response;

  switch (method) {
    case 'get':
      response = await http.get(
        url,
        headers: headers,
      );

      var responseBody = jsonDecode(response.body);

      if (responseBody['success'] == true) {
        return responseBody['body'];
      }
      return [];

    case 'post':
      response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      var responseBody = jsonDecode(response.body);

      return responseBody['success'] == true;

    case 'put':
      response = await http.put(
        url,
        headers: headers,
        body: body,
      );

      var responseBody = jsonDecode(response.body);

      if (responseBody['success'] == true) {
        return responseBody['body'];
      }
      return [];

    default:
      print('method is not allowed');
      break;
  }

  return [];
}
