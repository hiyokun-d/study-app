import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Primary button widget with loading state
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.backgroundColor,
    this.textColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconPosition iconPosition;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = widget.isEnabled && !widget.isLoading
        ? widget.onPressed
        : null;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? AppColors.primary,
          foregroundColor: widget.textColor ?? Colors.white,
          disabledBackgroundColor: AppColors.textDisabled,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          elevation: 0,
        ),
        child: widget.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (widget.icon == null) {
      return Text(
        widget.text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    final iconWidget = Icon(widget.icon, size: 20);
    final textWidget = Text(
      widget.text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: widget.iconPosition == IconPosition.left
          ? [
              iconWidget,
              const SizedBox(width: AppSizes.sm),
              textWidget,
            ]
          : [
              textWidget,
              const SizedBox(width: AppSizes.sm),
              iconWidget,
            ],
    );
  }
}

enum IconPosition { left, right }
