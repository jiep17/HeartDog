class Dog {
  final String id;
  final String ownerId;
  final String name;
  final int age;
  final double weight;
  final String veterinarianId;
  final String breedId;
  String breedName ="";
  final String note;

  Dog({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.age,
    required this.weight,
    required this.veterinarianId,
    required this.breedId,
    required this.note
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      weight: (json['weight'] as num).toDouble(),
      veterinarianId: json['veterinarian_id'] as String? ?? '',
      breedId: json['breed_id'] as String,
      note: json['note'] as String? ?? ''
    );
  }



Map<String, dynamic> toJson() {
  Map<String, dynamic> json = {
    'id': id,
    'owner_id': ownerId,
    'name': name,
    'age': age,
    'weight': weight,
    'breed_id': breedId,
    'note': note
  };

  if (veterinarianId.isNotEmpty) {
    json['veterinarian_id'] = veterinarianId;
  }

  return json;
}

Map<String, dynamic> toJsonUpdate() {
  Map<String, dynamic> json = {
    'name': name,
    'age': age,
    'weight': weight,
    'breed_id': breedId,
    'note': note
  };
  if (veterinarianId.isNotEmpty) {
    json['veterinarian_id'] = veterinarianId;
  }
  return json;
}

}
