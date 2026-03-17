import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              RouteNames.mainNavigation,
            );
          },
          child: const Text('Go To Main App'),
        ),
      ),
    );
  }
}