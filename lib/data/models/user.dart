class User {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String? profileImageUrl;
  
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? json['email']?.split('@')[0] ?? '',
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'username': username,
      'profile_image_url': profileImageUrl,
    };
  }
}
