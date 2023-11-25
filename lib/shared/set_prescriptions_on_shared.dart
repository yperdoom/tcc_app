import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void setPrescriptionsOnShared(var prescriptionsReceived) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt(
    'save.prescription.length',
    prescriptionsReceived.length - 1,
  );
  for (int counter = 0; counter < prescriptionsReceived.length; counter++) {
    String prescription = jsonEncode(
      prescriptionsReceived[counter],
    ).toString();

    await prefs.setString('save.prescription.$counter', prescription);
  }
}
