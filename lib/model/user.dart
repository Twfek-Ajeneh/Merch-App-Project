import 'dart:convert';

class User {
  String? token;
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? password_confirmation;
  final String? phone_number;
  String? image_url;

  User({
    this.token,
    this.id,
    this.name,
    this.email,
    this.password,
    this.password_confirmation,
    this.phone_number,
    this.image_url,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation,
      'phone_number': phone_number,
      'image_url': image_url,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      token: map['token'],
      id: map['id']?.toInt(),
      name: map['name'],
      email: map['email'],
      password: map['password'],
      password_confirmation: map['password_confirmation'],
      phone_number: map['phone_number'],
      image_url: map['image_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(var source) => User.fromMap(source);
}
