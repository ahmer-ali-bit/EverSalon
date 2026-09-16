import 'package:flutter/material.dart';
import 'package:ever_salon/constants/app_colors.dart';

class ValidationAlert extends StatelessWidget {
  final List<String> errors;

  const ValidationAlert({super.key, required this.errors});

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        children: errors.map((error) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  error,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
