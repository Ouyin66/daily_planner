import 'dart:convert';

class User {
  int? id;
  String? email;
  String? name;
  String? password;
  int? role;

  User({this.id, this.email, this.name, this.password, this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['role'] = role;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'] ?? 0,
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        password: map['password'] ?? '',
        role: map['role'] ?? 0);
  }

  String toJsonSQLite() => json.encode(toMap());

  factory User.fromJsonSQLite(String source) =>
      User.fromMap(json.decode(source));
}
