import 'package:flutter/material.dart';

import '../services/app_session.dart';
import '../services/booking_api.dart';
import '../theme/wtr_theme.dart';
import '../widgets/common.dart';
import 'create_account_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController(text: 'alex@example.com');
  final _password = TextEditingController(text: 'password');
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await session.signIn(email: _email.text, password: _password.text);
      if (mounted) Navigator.of(context).pop();
    } on AuthException catch (e) {
      _toast(e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
    final p = paletteOf(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.card,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(title: const Text('Sign in')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Text(
            'Welcome back.',
            style: TextStyle(color: p.ink, fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Sign in to book sessions and manage your membership.',
            style: TextStyle(color: p.muted, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: p.ink),
            decoration: const InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: _obscure,
            style: TextStyle(color: p.ink),
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _toast('Password reset (demo)'),
              child: Text('Forgot password?', style: TextStyle(color: p.muted, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 8),
          PillButton(
            label: 'Sign in',
            loading: _loading,
            onTap: _loading ? null : _submit,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?",
                  style: TextStyle(color: p.muted, fontSize: 14)),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
                ),
                child: Text('Create one',
                    style: TextStyle(
                        color: p.ink, fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
