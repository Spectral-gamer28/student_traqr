import 'package:flutter/material.dart';
import 'home_screen.dart';

enum SignUpRole { student, teacher }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SignUpRole _selectedRole = SignUpRole.student;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final roleStr = _selectedRole == SignUpRole.teacher ? 'Teacher' : 'Student';

      // For testing, navigate to home and pass role
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyHomePage(title: 'Home', role: roleStr)),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed up $name as $roleStr (test)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter email';
                  if (!v.contains('@')) return 'Enter valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter password';
                  if (v.length < 6) return 'Password too short';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Create account as:'),
              RadioListTile<SignUpRole>(
                title: const Text('Student'),
                value: SignUpRole.student,
                groupValue: _selectedRole,
                onChanged: (v) => setState(() => _selectedRole = v ?? SignUpRole.student),
              ),
              RadioListTile<SignUpRole>(
                title: const Text('Teacher'),
                value: SignUpRole.teacher,
                groupValue: _selectedRole,
                onChanged: (v) => setState(() => _selectedRole = v ?? SignUpRole.student),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Create account'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back')),
            ],
          ),
        ),
      ),
    );
  }
}
