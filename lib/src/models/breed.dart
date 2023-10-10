class Breed {
  String id;
  String name;

  Breed({
    required this.id,
    required this.name,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['data']['id'],
      name: json['data']['name'],
    );
  }

  factory Breed.fromJsonList(Map<String, dynamic> json) {
    return Breed(
      id: json['id'],
      name: json['name'],
    );
  }
}
