import 'package:flutter/material.dart';
import 'package:ever_salon/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? errorText; // optional field-level error
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError ? AppColors.error : AppColors.divider(context),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscure : false,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        style: TextStyle(fontSize: 15, color: AppColors.textPrimary(context)),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: AppColors.textSecondary(context), fontSize: 15),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: hasError ? AppColors.error : AppColors.textSecondary(context),
            size: 22,
          ),
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary(context),
                    size: 22,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}
