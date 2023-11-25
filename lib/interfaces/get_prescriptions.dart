import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/session.dart';
import 'package:http/http.dart' as http;

import '../shared/set_prescriptions_on_shared.dart';

String baseUrl = Session.baseUrl;

Future<dynamic> getPrescriptions(String search) async {
  print('get prescriptions function in home_user');
  print('session userid :: ${Session.userId}');
  var prescriptionsReceived = [];

  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token').toString();
  if (Session.userId == '') {
    Session.userId = prefs.getString('userid').toString();

    print('new session userid :: ${Session.userId}');
  }

  Map<String, String>? headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': token
  };

  Uri url = Uri.parse('$baseUrl/prescriptions/${Session.userId}?search=$search');

  print('url :: $url');

  http.Response response = await http.get(
    url,
    headers: headers,
  );
  var body = await jsonDecode(response.body);

  print('response with ${body['success'] ? 'success and the body is ${body['body']['prescriptions'].length} prescriptions' : 'not success'}');

  if (body['success'] == true) {
    if (body['body']['count'] > 0) {
      prescriptionsReceived = body['body']['prescriptions'];

      Session.firstAcessHome = false;
      prefs.setString('firstacesshome', 'false');

      setPrescriptionsOnShared(prescriptionsReceived);
    } else {
      setPrescriptionsOnShared([]);

      Session.firstAcessHome = false;
      prefs.setString('firstacesshome', 'false');
      prescriptionsReceived = [];
    }
  } else {
    setPrescriptionsOnShared([]);

    Session.firstAcessHome = false;
    prefs.setString('firstacesshome', 'false');
    prescriptionsReceived = [];
  }

  return prescriptionsReceived;
}
