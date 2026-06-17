import 'package:event_hub/core/widgets/blue_primary_button.dart';
import 'package:event_hub/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_redirect_text.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_text_field.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/or_divider.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/social_login_button.dart';
import 'package:event_hub/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  _SignUpView();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          } else if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account created successfully!')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
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
                    keyboardType: TextInputType.name, onToggle: () {  },
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _emailController,
                    hint: "abc@email.com",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress, onToggle: () {  },
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _passwordController,
                    hint: "Your password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: !state.isPasswordVisible,
                    showToggle: true,
                    onToggle: () => context.read<AuthCubit>().togglePasswordVisibility(),
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    hint: "Confirm password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: !state.isPasswordVisible,
                    showToggle: true,
                    onToggle: () => context.read<AuthCubit>().togglePasswordVisibility(),
                  ),
                  const SizedBox(height: 24),
                  state.isLoading 
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF5669FF)))
                      : BluePrimaryButton(
                          label: "SIGN UP", 
                          onPressed: () {
                            if (_passwordController.text != _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Passwords do not match')),
                              );
                              return;
                            }
                            context.read<AuthCubit>().signUp(
                              _nameController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
                          },
                        ),
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
          );
        },
      ),
    );
  }
}