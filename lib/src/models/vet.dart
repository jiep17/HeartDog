class Vet {
  String id;
  String name;
  String lastname;
  String phone;
  String clinicName;
  String disponibilityStart;
  String disponibilityEnd;

  Vet({
    required this.id,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.clinicName,
    required this.disponibilityStart,
    required this.disponibilityEnd,
  });

  factory Vet.fromJson(Map<String, dynamic> json) {
    return Vet(
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      phone: json['phone'],
      clinicName: json['clinic_name'],
      disponibilityStart: json['disponibility_start'],
      disponibilityEnd: json['disponibility_end'],
    );
  }
}
