String getBasedQuantity(var food) {
  if (food['weight'] != null) {
    return 'Peso base: ${food['weight']}g';
  }

  if (food['portion'] != null) {
    return 'Porções base: ${food['portion']}';
  }

  if (food['mililiter'] != null) {
    return 'Litragem base: ${food['mililiter']}ml';
  }
  return 'Não foi possível identificar o tipo de quantificação base utilizada nesse alimento!';
}
