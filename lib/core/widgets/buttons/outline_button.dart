import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Outline button widget with optional icon
class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.width,
    this.height,
    this.icon,
    this.borderColor,
    this.textColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double? width;
  final double? height;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isEnabled ? onPressed : null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppSizes.buttonHeight,
      child: OutlinedButton(
        onPressed: effectiveOnPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          disabledForegroundColor: AppColors.textDisabled,
          side: BorderSide(
            color: isEnabled
                ? (borderColor ?? AppColors.primary)
                : AppColors.textDisabled,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon == null) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppSizes.sm),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
