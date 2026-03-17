import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Alexandria',
            fontSize: 14,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            hintText: widget.placeholder,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.42),
              fontFamily: 'Alexandria',
              fontSize: 13,
            ),
            filled: true,
            fillColor: Color(0xFF2c2c2c),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(27.5),
              borderSide: BorderSide(color: Color(0xFF3f3f3f)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(27.5),
              borderSide: BorderSide(color: Color(0xFF3f3f3f), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(27.5),
              borderSide: BorderSide(color: Color(0xFF3f3f3f)),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withValues(alpha: 0.42),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.42),
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
