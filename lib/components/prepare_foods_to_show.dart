String prepareFoodsToShow(foods) {
  String message = '';

  if (foods.isNotEmpty && foods.length > 0) {
    message = 'Alimentos:';
    for (int i = 0; i < foods.length; i++) {
      message = '$message ${foods[i]['weight']}g de ${foods[i]['name']}';
    }
  }

  return message.isNotEmpty ? message : 'Nenhum alimento encontrado';
}
