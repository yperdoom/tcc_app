// ignore_for_file: use_build_context_synchronously

import 'package:Yan/components/verification_first_acess.dart';
import 'package:Yan/configs/session.dart';
import 'package:Yan/enumerators/redirect_view_pages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void verificationToken(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String? url = prefs.getString('url');
  String? env = prefs.getString('env');

  await verificationFirstAcess(prefs);

  if (url != null) {
    Session.baseUrl = url.toString();
  }

  if (env != null) {
    Session.env = env.toString();
  }

  if (token == null || token.isEmpty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => redirectViewPages('login')),
    );
  }
  final String? scope = prefs.getString('scope');

  if (scope == null || scope.isEmpty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => redirectViewPages('login')),
    );
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => redirectViewPages(scope)),
  );
}
