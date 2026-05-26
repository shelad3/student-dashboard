import '../models/user_model.dart';

class AuthResult {
  final bool success;
  final String? error;
  final String? uid;

  const AuthResult({required this.success, this.error, this.uid});
}

class AuthService {
  final _users = <String, Map<String, dynamic>>{
    'STU001': {
      'uid': 'stu001',
      'reg_number': 'STU001',
      'phone_number': '0712345678',
      'password_hash': 'password123',
      'role': 'student',
      'full_name': 'Alice Mwangi',
      'profile_pic_url': null,
      'is_first_login': true,
    },
    'STU002': {
      'uid': 'stu002',
      'reg_number': 'STU002',
      'phone_number': '0712345679',
      'password_hash': 'password123',
      'role': 'student',
      'full_name': 'Brian Kiprop',
      'profile_pic_url': null,
      'is_first_login': true,
    },
    '0711111111': {
      'uid': 'tch001',
      'reg_number': 'TCH001',
      'phone_number': '0711111111',
      'password_hash': 'password123',
      'role': 'teacher',
      'full_name': 'Dr. Jane Wanjiku',
      'profile_pic_url': null,
      'is_first_login': true,
    },
    '0711111112': {
      'uid': 'tch002',
      'reg_number': 'TCH002',
      'phone_number': '0711111112',
      'password_hash': 'password123',
      'role': 'teacher',
      'full_name': 'Mr. Peter Otieno',
      'profile_pic_url': null,
      'is_first_login': true,
    },
    '0711111113': {
      'uid': 'tch003',
      'reg_number': 'TCH003',
      'phone_number': '0711111113',
      'password_hash': 'password123',
      'role': 'teacher',
      'full_name': 'Ms. Grace Nyambura',
      'profile_pic_url': null,
      'is_first_login': true,
    },
    '0711111114': {
      'uid': 'tch004',
      'reg_number': 'TCH004',
      'phone_number': '0711111114',
      'password_hash': 'password123',
      'role': 'teacher',
      'full_name': 'Mr. David Kamau',
      'profile_pic_url': null,
      'is_first_login': true,
    },
    'ADM001': {
      'uid': 'adm001',
      'reg_number': 'ADM001',
      'phone_number': '0700000000',
      'password_hash': 'password123',
      'role': 'admin',
      'full_name': 'Admin User',
      'profile_pic_url': null,
      'is_first_login': false,
    },
  };

  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  AuthResult login(String username, String password) {
    final isPhone = RegExp(r'^0\d{9}$').hasMatch(username);
    final key = isPhone ? username : username.toUpperCase();
    final data = _users[key];

    if (data == null) {
      return const AuthResult(success: false, error: 'Invalid credentials');
    }
    if (data['password_hash'] != password) {
      return const AuthResult(
        success: false,
        error: 'Invalid credentials. Please contact Class Admin.',
      );
    }

    _currentUser = AppUser(
      uid: data['uid'],
      regNumber: data['reg_number'],
      phoneNumber: data['phone_number'],
      passwordHash: data['password_hash'],
      role: UserRole.values.firstWhere((r) => r.name == data['role']),
      fullName: data['full_name'],
      profilePicUrl: data['profile_pic_url'],
      isFirstLogin: data['is_first_login'],
    );
    return AuthResult(success: true, uid: data['uid']);
  }

  void completeFirstLogin() {
    if (_currentUser == null) return;
    _users[_currentUser!.regNumber]!['is_first_login'] = false;
    _users[_currentUser!.phoneNumber]!['is_first_login'] = false;
    _currentUser = AppUser(
      uid: _currentUser!.uid,
      regNumber: _currentUser!.regNumber,
      phoneNumber: _currentUser!.phoneNumber,
      passwordHash: _currentUser!.passwordHash,
      role: _currentUser!.role,
      fullName: _currentUser!.fullName,
      profilePicUrl: _currentUser!.profilePicUrl,
      isFirstLogin: false,
    );
  }

  void changePassword(String newPassword) {
    if (_currentUser == null) return;
    _users[_currentUser!.regNumber]!['password_hash'] = newPassword;
    _users[_currentUser!.phoneNumber]!['password_hash'] = newPassword;
    _currentUser = AppUser(
      uid: _currentUser!.uid,
      regNumber: _currentUser!.regNumber,
      phoneNumber: _currentUser!.phoneNumber,
      passwordHash: newPassword,
      role: _currentUser!.role,
      fullName: _currentUser!.fullName,
      profilePicUrl: _currentUser!.profilePicUrl,
      isFirstLogin: _currentUser!.isFirstLogin,
    );
  }

  void updateProfilePic(String url) {
    if (_currentUser == null) return;
    _users[_currentUser!.regNumber]!['profile_pic_url'] = url;
    _users[_currentUser!.phoneNumber]!['profile_pic_url'] = url;
    _currentUser = AppUser(
      uid: _currentUser!.uid,
      regNumber: _currentUser!.regNumber,
      phoneNumber: _currentUser!.phoneNumber,
      passwordHash: _currentUser!.passwordHash,
      role: _currentUser!.role,
      fullName: _currentUser!.fullName,
      profilePicUrl: url,
      isFirstLogin: _currentUser!.isFirstLogin,
    );
  }

  void logout() {
    _currentUser = null;
  }
}
