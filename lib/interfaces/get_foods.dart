import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/session.dart';
import 'package:http/http.dart' as http;

import '../shared/set_foods_on_shared.dart';

String baseUrl = Session.baseUrl;

Future<dynamic> getFoods(String search) async {
  print('get foods function in food_user');
  print('session userid :: ${Session.userId}');
  var foodsReceived = [];
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token').toString();
  if (Session.userId == '') {
    Session.userId = prefs.getString('userid').toString();

    print('new session userid :: ${Session.userId}');
  }

  Uri url = Uri.parse('$baseUrl/foods');

  print('url :: $url');

  if (search.length >= 2) {
    print('search :: $search');
    url = Uri.parse('$baseUrl/foods?find=$search');
  }
  Map<String, String>? headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': token
  };

  http.Response response = await http.get(
    url,
    headers: headers,
  );
  var body = await jsonDecode(response.body);

  print('response with ${body['success'] ? 'success and the body is ${body['body']['foods'].length} foods' : 'not success'}');

  print(body['success']);
  if (body['success'] == true) {
    print('foods on route :: ${body['body']}');
    if (body['body']['count'] > 0) {
      foodsReceived = body['body']['foods'];
    }
    setFoodsOnShared(foodsReceived);
  } else {
    foodsReceived = [];
  }

  Session.firstAcessFood = false;
  prefs.setString('firstacessfood', 'false');

  return foodsReceived;
}
