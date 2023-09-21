class Owner {
  final String id;
  final String name;
  final String lastname;
  final String email;
  final String password;
  final String phone;

  Owner({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.password,
    required this.phone,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] as String,
      name: json['name'] as String,
      lastname: json['lastname'] as String,
      email: json['email'] as String,
      password: json['password'] as String? ?? '',
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }
}
