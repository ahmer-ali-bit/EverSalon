import 'package:flutter/material.dart';
import 'package:ever_salon/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final bool isLoading;
  final bool isEnabled; // NEW: disabled state support

  const CustomButton({
    super.key,
    this.text,
    this.icon,
    required this.onTap,
    this.width = double.infinity,
    this.height = 55.0,
    this.isLoading = false,
    this.isEnabled = true, // default enabled
  });

  @override
  Widget build(BuildContext context) {
    final bool canTap = isEnabled && !isLoading && onTap != null;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: canTap ? AppColors.primaryGradient : null,
        color: canTap ? null : AppColors.textSecondary(context).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(30),
        boxShadow: canTap
            ? [
                BoxShadow(
                  color: AppColors.primaryPink.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: canTap ? onTap : null,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : text != null
                ? Text(
                    text!,
                    style: TextStyle(
                      color: canTap ? AppColors.textWhite : AppColors.textSecondary(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    icon ?? Icons.arrow_forward_rounded,
                    color: canTap ? AppColors.textWhite : AppColors.textSecondary(context),
                    size: 22,
                  ),
          ),
        ),
      ),
    );
  }
}
