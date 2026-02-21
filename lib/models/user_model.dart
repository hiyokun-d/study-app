/// User model representing both students and teachers
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.phone,
    this.avatar,
    this.bio,
    this.role = UserRole.student,
    this.createdAt,
    this.isVerified = false,
    this.isOnline = false,
  });

  final String id;
  final String name;
  final String email;
  final String? username;
  final String? phone;
  final String? avatar;
  final String? bio;
  final UserRole role;
  final DateTime? createdAt;
  final bool isVerified;
  final bool isOnline;

  /// Get user initials for avatar placeholder
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  /// Copy with new values
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    String? phone,
    String? avatar,
    String? bio,
    UserRole? role,
    DateTime? createdAt,
    bool? isVerified,
    bool? isOnline,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

/// User role enum
enum UserRole {
  student,
  teacher,
}

/// Extension for UserRole
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
    }
  }
}
