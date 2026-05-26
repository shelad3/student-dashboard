enum UserRole { student, teacher, admin }

class AppUser {
  final String uid;
  final String regNumber;
  final String phoneNumber;
  final String passwordHash;
  final UserRole role;
  final String fullName;
  final String? profilePicUrl;
  final bool isFirstLogin;

  const AppUser({
    required this.uid,
    required this.regNumber,
    required this.phoneNumber,
    required this.passwordHash,
    required this.role,
    required this.fullName,
    this.profilePicUrl,
    this.isFirstLogin = true,
  });
}
