import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';

/// Custom checkbox used for Terms of Service & Privacy Policy agreements.
class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.secondaryLabel,
    this.onSecondaryLabelTap,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryLabelTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: (checked) {
                if (checked != null) {
                  onChanged(checked);
                }
              },
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    TextSpan(text: label),
                    if (secondaryLabel != null) ...[
                      const TextSpan(text: ' '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: onSecondaryLabelTap,
                          child: Text(
                            secondaryLabel!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

