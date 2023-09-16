class Breed {
  String id;
  String name;

  Breed({
    required this.id,
    required this.name,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'],
      name: json['name'],
    );
  }
}
