class Dog {
  final String id;
  final String owner_id;
  final String name;
  final int age;
  final double weight;
  final String veterinarian_id;
  final String breed_id;
  final String note;

  Dog({
    required this.id,
    required this.owner_id,
    required this.name,
    required this.age,
    required this.weight,
    required this.veterinarian_id,
    required this.breed_id,
    required this.note
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] as String,
      owner_id: json['owner_id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      weight: (json['weight'] as num).toDouble(),
      veterinarian_id: json['veterinarian_id'] as String,
      breed_id: json['breed_id'] as String,
      note: json['note'] as String? ?? ''
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': owner_id,
      'name': name,
      'age': age,
      'weight': weight,
      'veterinarian_id': veterinarian_id,
      'breed_id': breed_id,
      'note': note
    };
  }
}
