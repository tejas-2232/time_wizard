class UserProfile {
  final String username;
  final String? displayName;
  final String? email;
  
  UserProfile({
    required this.username,
    this.displayName,
    this.email,
  });
  
  UserProfile copyWith({
    String? username,
    String? displayName,
    String? email,
  }) {
    return UserProfile(
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      'email': email,
    };
  }
  
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      displayName: json['displayName'],
      email: json['email'],
    );
  }
}