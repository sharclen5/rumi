class Meal {
  final String time;
  final String type; // "ASI", "Sarapan", "Makan Siang", "Makan Malam", "Snack"
  final String? name; // null for ASI slots
  final List<String>? ingredients;
  final List<String>? steps;
  final String? reason;
  final bool isEaten;

  Meal({
    required this.time,
    required this.type,
    this.name,
    this.ingredients,
    this.steps,
    this.reason,
    this.isEaten = false,
  });

  // convert JSON from API response to Meal object
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      time: json['time'],
      type: json['type'],
      name: json['name'],
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
      steps: json['steps'] != null ? List<String>.from(json['steps']) : null,
      reason: json['reason'],
      isEaten: json['isEaten'] ?? false,
    );
  }

  // convert ke JSON buat nyimpen di Firestore
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'type': type,
      'name': name,
      'ingredients': ingredients,
      'steps': steps,
      'reason': reason,
      'isEaten': isEaten,
    };
  }

  // since Meal is immutable — toggling creates a new instance
  Meal copyWith({bool? isEaten}) {
    return Meal(
      time: time,
      type: type,
      name: name,
      ingredients: ingredients,
      steps: steps,
      reason: reason,
      isEaten: isEaten ?? this.isEaten,
    );
  }
}
