import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  AppUser? get currentUser => _authService.currentUser;
  bool get isLoggedIn => _authService.currentUser != null;
  bool get isFirstLogin => _authService.currentUser?.isFirstLogin ?? false;
  bool get isTeacher =>
      _authService.currentUser?.role == UserRole.teacher;
  bool get isAdmin => _authService.currentUser?.role == UserRole.admin;
  bool get isStudent =>
      _authService.currentUser?.role == UserRole.student;

  AuthResult login(String username, String password) {
    final result = _authService.login(username, password);
    if (result.success) notifyListeners();
    return result;
  }

  void completeFirstLogin() {
    _authService.completeFirstLogin();
    notifyListeners();
  }

  void changePassword(String newPassword) {
    _authService.changePassword(newPassword);
    notifyListeners();
  }

  void updateProfilePic(String url) {
    _authService.updateProfilePic(url);
    notifyListeners();
  }

  void logout() {
    _authService.logout();
    notifyListeners();
  }
}
