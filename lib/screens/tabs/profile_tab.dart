import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _showPwForm = false;
  final _oldPwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();

  @override
  void dispose() {
    _oldPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  void _changePassword() {
    final old = _oldPwCtrl.text.trim();
    final newPw = _newPwCtrl.text.trim();
    final confirm = _confirmPwCtrl.text.trim();

    if (old.isEmpty || newPw.isEmpty) {
      _showError('Fill all fields');
      return;
    }
    if (newPw.length < 6) {
      _showError('New password must be at least 6 characters');
      return;
    }
    if (newPw != confirm) {
      _showError('Passwords do not match');
      return;
    }

    context.read<AuthProvider>().changePassword(newPw);
    setState(() => _showPwForm = false);
    _oldPwCtrl.clear();
    _newPwCtrl.clear();
    _confirmPwCtrl.clear();
    _showSuccess('Password changed successfully');
  }

  void _logout() {
    context.read<AuthProvider>().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return ListView(
      padding: EdgeInsets.all(24),
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  (user?.fullName ?? '?')[0],
                  style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Center(
          child: Text(
            user?.fullName ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Center(
          child: Text(
            user?.role.name.toUpperCase() ?? '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 4),
        Center(
          child: Text(
            user?.regNumber ?? '',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        SizedBox(height: 32),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.badge_outlined),
                title: Text('Registration'),
                subtitle: Text(user?.regNumber ?? ''),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.phone_outlined),
                title: Text('Phone'),
                subtitle: Text(user?.phoneNumber ?? ''),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Role'),
                subtitle: Text(
                  '${user?.role.name[0].toUpperCase()}${user?.role.name.substring(1) ?? ''}',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('Change Password'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => setState(() => _showPwForm = !_showPwForm),
              ),
              if (_showPwForm) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _oldPwCtrl,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _newPwCtrl,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _confirmPwCtrl,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _changePassword,
                          child: Text('Update Password'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: Icon(Icons.logout, color: Colors.red),
          label: Text('Log Out', style: TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.red.shade200),
          ),
        ),
      ],
    );
  }
}
