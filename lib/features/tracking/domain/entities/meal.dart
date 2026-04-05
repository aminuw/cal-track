class Meal {
  final String id;
  final String foodItem;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final DateTime createdAt;

  Meal({
    required this.id,
    required this.foodItem,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.createdAt,
  });
}
