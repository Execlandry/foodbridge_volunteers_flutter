class MenuItem {
  final String id;
  final String name;
  final String quantity;
  final String foodType;
  final String thumbnail;

  MenuItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.foodType,
    required this.thumbnail,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      foodType: json['food_type'],
      thumbnail: json['thumbnails'],
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'quantity': quantity,
    'food_type': foodType,
    'thumbnail': thumbnail,
  };
}
}
