import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AdminNotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final double? top;
  final double? right;

  const AdminNotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.top,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            top: top ?? -4,
            right: right ?? -6,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: count > 9 ? w * 0.012 : w * 0.015,
                vertical: w * 0.005,
              ),
              constraints: BoxConstraints(
                minWidth: w * 0.045,
                minHeight: w * 0.045,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryPink,
                borderRadius: BorderRadius.circular(w * 0.03),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPink.withValues(alpha: 0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.025,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
