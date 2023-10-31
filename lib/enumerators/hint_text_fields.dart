String hintTextField(String text) {
  if (text == 'E-mail') {
    return 'Digite teu e-mail aqui...';
  }

  if (text == 'Senha') {
    return 'Digite tua nova senha aqui...';
  }

  if (text == 'Nome') {
    return 'Digite teu nome aqui...';
  }

  if (text == 'Celular') {
    return 'Digite teu celular aqui...';
  }

  if (text == 'Aniversário') {
    return 'Escolha sua data de nascimento';
  }

  if (text == 'Altura') {
    return 'Digite (em cm) tua altura aqui...';
  }

  if (text == 'Peso') {
    return 'Digite (em KG) teu peso aqui...';
  }

  if (text == 'Porcentagem de gordura') {
    return 'Digite qual é teu percentual de gordura aqui...';
  }

  if (text == 'Sexo') {
    return 'Escolha qual é teu sexo aqui...';
  }

  return '...';
}
