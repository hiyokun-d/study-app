import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

/// Modern search input widget with theme-aware styling
class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    this.hint = 'Search...',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.focusNode,
    this.autofocus = false,
    this.showFilter = false,
    this.onFilterTap,
    this.fillColor,
    this.size = SearchInputSize.medium,
    this.showBorder = true,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool showFilter;
  final VoidCallback? onFilterTap;
  final Color? fillColor;
  final SearchInputSize size;
  final bool showBorder;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  double get _inputHeight {
    switch (widget.size) {
      case SearchInputSize.small:
        return 40;
      case SearchInputSize.medium:
        return 48;
      case SearchInputSize.large:
        return 56;
    }
  }

  double get _fontSize => widget.size == SearchInputSize.small ? 14 : 16;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final effectiveFillColor = widget.fillColor ?? 
        colorScheme.surfaceContainerHighest.withOpacity(0.5);

    return Container(
      height: _inputHeight,
      decoration: BoxDecoration(
        color: effectiveFillColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: widget.showBorder
            ? Border.all(
                color: colorScheme.outlineVariant,
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          // Search Icon
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.md),
            child: Icon(
              Icons.search_rounded,
              size: _fontSize + 6,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          
          // Text Field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
              style: textTheme.bodyLarge?.copyWith(
                fontSize: _fontSize,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.sm,
                ),
                isDense: true,
              ),
            ),
          ),
          
          // Clear Button
          if (_hasText)
            AnimatedOpacity(
              opacity: _hasText ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: _fontSize + 2,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: _clearText,
                padding: const EdgeInsets.all(AppSizes.sm),
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
              ),
            ),
          
          // Filter Button
          if (widget.showFilter)
            Container(
              margin: const EdgeInsets.only(right: AppSizes.xs),
              child: IconButton(
                icon: Icon(
                  Icons.tune_rounded,
                  size: _fontSize + 4,
                  color: colorScheme.primary,
                ),
                onPressed: widget.onFilterTap,
                padding: const EdgeInsets.all(AppSizes.sm),
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum SearchInputSize { small, medium, large }
