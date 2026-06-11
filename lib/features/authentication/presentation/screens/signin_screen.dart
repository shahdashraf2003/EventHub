import 'package:event_hub/features/authentication/presentation/screens/signup_screen.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_primary_button.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_redirect_text.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_text_field.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/or_divider.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/social_login_button.dart';
import 'package:flutter/material.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
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
              const Text(
                "Sign in",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 20),

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


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: true,
                        onChanged: (_) {},
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
              AuthPrimaryButton(label: "SIGN IN", onPressed: () {}),
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
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}