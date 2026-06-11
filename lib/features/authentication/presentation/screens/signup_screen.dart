import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_primary_button.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_redirect_text.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_text_field.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/or_divider.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/social_login_button.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              const AuthTextField(
                hint: "Full name",
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 14),
              const AuthTextField(
                hint: "abc@email.com",
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 14),
              const AuthTextField(
                hint: "Your password",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                showToggle: true,
              ),

              const SizedBox(height: 14),
              const AuthTextField(
                hint: "Confirm password",
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                showToggle: true,
              ),

              const SizedBox(height: 24),
              AuthPrimaryButton(label: "SIGN UP", onPressed: () {}),

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