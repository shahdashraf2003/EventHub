import 'package:event_hub/core/widgets/blue_primary_button.dart';
import 'package:event_hub/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:event_hub/features/authentication/presentation/screens/signup_screen.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_redirect_text.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_text_field.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/or_divider.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/social_login_button.dart';
import 'package:event_hub/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: _SignInView(),
    );
  }
}

class _SignInView extends StatelessWidget {
  _SignInView();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget _buildSavedAccounts(BuildContext context, List<Map<String, String>> savedAccounts) {
    if (savedAccounts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent accounts",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: savedAccounts.length,
            itemBuilder: (context, index) {
              final account = savedAccounts[index];
              return GestureDetector(
                onTap: () {
                  _emailController.text = account['email'] ?? '';
                  _passwordController.text = account['password'] ?? '';
                  context.read<AuthCubit>().signIn(_emailController.text, _passwordController.text);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF5669FF),
                        child: Text(
                          (account['name'] ?? 'U').isNotEmpty ? (account['name'] ?? 'U').substring(0, 1).toUpperCase() : 'U',
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        account['name']?.split(' ').first ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/images/e.png', width: 64, height: 64),
                        const SizedBox(height: 10),
                        const Text(
                          "EventHub",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  
                  _buildSavedAccounts(context, state.savedAccounts),

                  const Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),

                  const SizedBox(height: 20),

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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Switch(
                            value: state.rememberMe,
                            onChanged: (val) {
                              context.read<AuthCubit>().toggleRememberMe(val);
                            },
                            activeThumbColor: const Color(0xFF5669FF),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF5669FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  
                  state.isLoading 
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF5669FF)))
                    : BluePrimaryButton(
                        label: "SIGN IN", 
                        onPressed: () => context.read<AuthCubit>().signIn(_emailController.text.trim(), _passwordController.text),
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
                    question: "Don't have an account?",
                    actionLabel: "Sign up",
                    onTap: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
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