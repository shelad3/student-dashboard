import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'app_shell.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final pw = _passwordCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    if (pw.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }
    if (pw != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    auth.changePassword(pw);
    auth.completeFirstLogin();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Set Up Profile')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                child: Text(
                  (user?.fullName ?? '?')[0],
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Welcome, ${user?.fullName ?? ''}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: Text(
                'Reg: ${user?.regNumber ?? ''}',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Change your default password:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordCtrl,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure1 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: _obscure1,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmCtrl,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: _obscure2,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _save,
                child: Text('Save & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
