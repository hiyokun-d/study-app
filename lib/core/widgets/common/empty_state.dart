import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

/// Modern empty state widget with theme-aware styling
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon,
    this.image,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.size = EmptyStateSize.medium,
  });

  final IconData? icon;
  final Widget? image;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EmptyStateSize size;

  double get _iconSize {
    switch (size) {
      case EmptyStateSize.small:
        return 48;
      case EmptyStateSize.medium:
        return 64;
      case EmptyStateSize.large:
        return 96;
    }
  }

  double get _titleFontSize {
    switch (size) {
      case EmptyStateSize.small:
        return 16;
      case EmptyStateSize.medium:
        return 18;
      case EmptyStateSize.large:
        return 20;
    }
  }

  double get _messageFontSize {
    switch (size) {
      case EmptyStateSize.small:
        return 12;
      case EmptyStateSize.medium:
        return 14;
      case EmptyStateSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or Image
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: _iconSize,
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else if (image != null)
            image!,
          
          const SizedBox(height: AppSizes.lg),
          
          // Title
          if (title != null)
            Text(
              title!,
              style: textTheme.titleLarge?.copyWith(
                fontSize: _titleFontSize,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          
          const SizedBox(height: AppSizes.sm),
          
          // Message
          if (message != null)
            Text(
              message!,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: _messageFontSize,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          
          // Action Button
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSizes.lg),
            FilledButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state widget
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'Please try again later',
    this.retryLabel = 'Retry',
    this.onRetry,
  });

  final String title;
  final String message;
  final String retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return EmptyState(
      icon: Icons.error_outline_rounded,
      title: title,
      message: message,
      actionLabel: onRetry != null ? retryLabel : null,
      onAction: onRetry,
      size: EmptyStateSize.medium,
    );
  }
}

/// No internet state widget
class NoInternetState extends StatelessWidget {
  const NoInternetState({
    super.key,
    this.retryLabel = 'Retry',
    this.onRetry,
  });

  final String retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.wifi_off_rounded,
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      actionLabel: onRetry != null ? retryLabel : null,
      onAction: onRetry,
      size: EmptyStateSize.medium,
    );
  }
}

/// No data state widget
class NoDataState extends StatelessWidget {
  const NoDataState({
    super.key,
    this.title = 'No Data Found',
    this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: icon,
      title: title,
      message: message ?? 'There is no data to display.',
      actionLabel: actionLabel,
      onAction: onAction,
      size: EmptyStateSize.medium,
    );
  }
}

enum EmptyStateSize { small, medium, large }
