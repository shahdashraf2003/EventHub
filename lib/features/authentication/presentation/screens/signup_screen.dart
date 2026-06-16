import 'package:event_hub/core/database/database_helper.dart';
import 'package:event_hub/core/widgets/blue_primary_button.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_redirect_text.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_text_field.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/or_divider.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/social_login_button.dart';
import 'package:event_hub/model/entities/user_model.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = UserModel(name: name, email: email, password: password);
      await DatabaseHelper.instance.createUser(user);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 24),
              const Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 24),
              AuthTextField(
                controller: _nameController,
                hint: "Full name",
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 14),
              AuthTextField(
                controller: _emailController,
                hint: "abc@email.com",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              AuthTextField(
                controller: _passwordController,
                hint: "Your password",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                showToggle: true,
              ),
              const SizedBox(height: 14),
              AuthTextField(
                controller: _confirmPasswordController,
                hint: "Confirm password",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                showToggle: true,
              ),
              const SizedBox(height: 24),
              _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : BluePrimaryButton(label: "SIGN UP", onPressed: _signUp),
              const SizedBox(height: 24),
              const OrDivider(),
              const SizedBox(height: 16),
              SocialLoginButton(
                label: "Login with Google",
                iconAsset: "assets/images/google.png",
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              SocialLoginButton(
                label: "Login with Facebook",
                iconAsset: "assets/images/facebook.png",
                onPressed: () {},
              ),
              const SizedBox(height: 24),
              AuthRedirectText(
                question: "Already have an account?",
                actionLabel: "Signin",
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}