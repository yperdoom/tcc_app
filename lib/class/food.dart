class Food {
  final String? food_id;
  final String? name;
  final bool? selected;

  Food({
    required this.food_id,
    required this.name,
    this.selected = false,
  });
}
