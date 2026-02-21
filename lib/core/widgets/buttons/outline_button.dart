import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

/// Outline button widget with modern styling
class OutlineButton extends StatefulWidget {
  const OutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.borderColor,
    this.textColor,
    this.size = ButtonSize.medium,
    this.isFilled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconPosition iconPosition;
  final Color? borderColor;
  final Color? textColor;
  final ButtonSize size;
  final bool isFilled;

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _buttonHeight {
    switch (widget.size) {
      case ButtonSize.small:
        return AppSizes.buttonHeightSm;
      case ButtonSize.medium:
        return AppSizes.buttonHeight;
      case ButtonSize.large:
        return AppSizes.buttonHeightLg;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final effectiveOnPressed = widget.isEnabled ? widget.onPressed : null;
    
    final borderColor = widget.borderColor ?? colorScheme.primary;
    final textColor = widget.textColor ?? colorScheme.primary;
    final fillColor = widget.isFilled 
        ? colorScheme.primaryContainer.withOpacity(0.3)
        : Colors.transparent;

    return GestureDetector(
      onTapDown: (_) {
        if (effectiveOnPressed != null) {
          _animationController.forward();
        }
      },
      onTapUp: (_) {
        if (effectiveOnPressed != null) {
          _animationController.reverse();
        }
      },
      onTapCancel: () {
        if (effectiveOnPressed != null) {
          _animationController.reverse();
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height ?? _buttonHeight,
          child: OutlinedButton(
            onPressed: effectiveOnPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor,
              backgroundColor: fillColor,
              disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
              side: BorderSide(
                color: widget.isEnabled 
                    ? borderColor
                    : colorScheme.onSurface.withOpacity(0.12),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
            child: _buildButtonContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (widget.icon == null) {
      return Text(
        widget.text,
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      );
    }

    final iconWidget = Icon(widget.icon, size: _iconSize);
    final textWidget = Text(
      widget.text,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
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

enum ButtonSize { small, medium, large }
