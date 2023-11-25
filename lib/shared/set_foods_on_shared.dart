import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void setFoodsOnShared(var foodsToSave) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt(
    'save.food.length',
    foodsToSave.length - 1,
  );
  for (int counter = 0; counter < foodsToSave.length; counter++) {
    String food = jsonEncode(
      foodsToSave[counter],
    ).toString();

    await prefs.setString('save.food.$counter', food);
  }
}
