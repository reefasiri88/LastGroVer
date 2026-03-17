import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Icon? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType keyboardType;
  final int maxLines;

  const AuthTextField({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.validator,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late FocusNode _focusNode;

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
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
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
            suffixIcon: widget.suffixIcon != null
                ? GestureDetector(
                    onTap: widget.onSuffixIconPressed,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: widget.suffixIcon,
                    ),
                  )
                : null,
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
