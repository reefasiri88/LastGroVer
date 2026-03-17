import 'package:flutter/material.dart';
import '../widgets/back_button_widget.dart';
import '../widgets/form_input_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/decorative_background.dart';

class PowerHourEventScreen extends StatefulWidget {
  const PowerHourEventScreen({super.key});

  @override
  State<PowerHourEventScreen> createState() => _PowerHourEventScreenState();
}

class _PowerHourEventScreenState extends State<PowerHourEventScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    // Navigate to success screen
    Navigator.pushNamed(context, '/events/success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecorativeBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: BackButtonWidget(
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Title
                  const Text(
                    'Register for Power Hour Event',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Subtitle
                  const Text(
                    'Fill in your details to secure your spot',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: -0.16,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Form fields
                  FormInputField(
                    label: 'First name',
                    controller: _firstNameController,
                  ),
                  const SizedBox(height: 20),
                  FormInputField(
                    label: 'Last name',
                    controller: _lastNameController,
                  ),
                  const SizedBox(height: 20),
                  FormInputField(
                    label: 'Contact number',
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  FormInputField(
                    label: 'Gender',
                    controller: _genderController,
                  ),
                  const SizedBox(height: 20),
                  FormInputField(
                    label: 'Email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  FormInputField(
                    label: 'Confirm email address',
                    controller: _confirmEmailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 60),
                  // Register button
                  GradientButton(
                    label: 'Register',
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
