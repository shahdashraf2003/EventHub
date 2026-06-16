import 'package:event_hub/core/database/database_helper.dart';
import 'package:event_hub/core/services/secure_storage_service.dart';
import 'package:event_hub/core/services/shared_prefs_service.dart';
import 'package:event_hub/core/widgets/blue_primary_button.dart';
import 'package:event_hub/features/authentication/presentation/screens/signup_screen.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_redirect_text.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/auth_text_field.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/or_divider.dart';
import 'package:event_hub/features/authentication/presentation/screens/widgets/social_login_button.dart';
import 'package:event_hub/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _isLoading = false;
  List<Map<String, String>> _savedAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadSavedAccounts();
  }

  Future<void> _loadSavedAccounts() async {
    final accounts = await SecureStorageService.getSavedAccounts();
    setState(() {
      _savedAccounts = accounts;
    });
  }

  void _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await DatabaseHelper.instance.getUserByEmailAndPassword(email, password);
      if (user != null) {
        await SharedPrefsService.setLoggedIn(true);
        await SharedPrefsService.setCurrentUserEmail(user.email);
        await SharedPrefsService.setCurrentUserName(user.name);
        if (user.id != null) {
          await SharedPrefsService.setCurrentUserId(user.id!);
        }
        
        if (_rememberMe) {
          await SecureStorageService.saveAccount(user.name, user.email, password);
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')),
          );
        }
      }
    } catch (e) {
       if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
       }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildSavedAccounts() {
    if (_savedAccounts.isEmpty) return const SizedBox.shrink();

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
            itemCount: _savedAccounts.length,
            itemBuilder: (context, index) {
              final account = _savedAccounts[index];
              return GestureDetector(
                onTap: () {
                  _emailController.text = account['email'] ?? '';
                  _passwordController.text = account['password'] ?? '';
                  _signIn(); 
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              
              _buildSavedAccounts(),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: _rememberMe,
                        onChanged: (val) {
                          setState(() => _rememberMe = val);
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
              
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : BluePrimaryButton(label: "SIGN IN", onPressed: _signIn),
                
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
      ),
    );
  }
}