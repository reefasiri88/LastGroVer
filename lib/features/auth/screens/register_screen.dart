import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../profile/logic/profile_store.dart';
import '../../profile/data/profile_service.dart';
import '../data/auth_service.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/auth_footer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authService = AuthService();
  final _profileService = ProfileService();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        mobile.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authResponse = await _authService.signUpUser(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) {
        throw Exception('Registration failed. Please try again.');
      }

      await _profileService.createProfile(
        userId: user.id,
        username: username,
        email: email,
        phoneNumber: mobile,
      );

      await ProfileStore.instance.saveProfilePatch(
        name: username,
        email: email,
        mobile: mobile,
      );

      await ProfileStore.instance.setLoggedIn(true);

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.setup,
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Hello! Register to get\nstarted',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Alexandria',
                  letterSpacing: -0.3,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),
              AuthTextField(
                label: 'Username',
                placeholder: 'Username',
                controller: _usernameController,
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: 'Email',
                placeholder: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: 'Mobile Number',
                placeholder: 'Mobile Number',
                controller: _mobileController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              PasswordField(
                label: 'Password',
                placeholder: 'Password',
                controller: _passwordController,
              ),
              const SizedBox(height: 20),
              PasswordField(
                label: 'Confirm password',
                placeholder: 'Confirm password',
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Register',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: AuthFooter(
                  mainText: 'Already have an account?',
                  linkText: 'Login Now',
                  onLinkTapped: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}