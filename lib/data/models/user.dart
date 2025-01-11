class User {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'email': email,
      'profile_image_url': profileImageUrl,
    };
  }
}
