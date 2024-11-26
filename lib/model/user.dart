class User {
  final int id;
  final String username;
  final String email;
  final String country;
  final String phone;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.country,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      country: json['country'],
      phone: json['phone'],
    );
  }
}
