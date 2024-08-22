class User {
  String phone;
  String avatar;
  String role;

  User({
    required this.phone,
    required this.avatar,
    required this.role
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phone: json['phone'],
      avatar: json['avatar'],
      role: json['role']
    );
  }

}