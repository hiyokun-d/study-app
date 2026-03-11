import 'package:flutter/material.dart';
import 'text_input.dart';

/// Password text field with built-in visibility toggle.
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.validator,
    this.size = InputSize.medium,
    this.borderColor, 
    this.borderRadius, 
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool enabled;
  final bool readOnly;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? Function(String?)? validator;
  final InputSize size;
  final Color? borderColor; 
  final double? borderRadius; 

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextInput(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      helperText: widget.helperText,
      prefixIcon: Icons.lock_outline_rounded,
      suffixIcon:
          _obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
      onSuffixIconPressed: _toggleVisibility,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLength: widget.maxLength,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      validator: widget.validator,
      size: widget.size,
      showBorder: true,
      borderColor: widget.borderColor, 
      borderRadius: widget.borderRadius, 
    );
  }
}