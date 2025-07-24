import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final List<TextInputFormatter>? formatters;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final IconData? suffixIcon;
  final String? Function(String? value) validator;
  final bool isEnabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.formatters,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon,
    required this.validator,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white, width: 1.25),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white, width: 1.25),
          ),
          label: Text(label),
          labelStyle: TextStyle(fontSize: 15, color: Colors.white),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon!, color: Colors.white)
              : null,
        ),
        style: TextStyle(fontSize: 15, color: Colors.white),
        inputFormatters: formatters,
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.words,
        obscureText: obscureText,
        maxLines: maxLines,
      ),
    );
  }
}
