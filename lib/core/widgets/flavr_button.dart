import 'package:flutter/material.dart';
import 'package:flavr/core/theme/app_colors.dart';

class FlavrButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? leadingIcon;
  final IconData? icon;
  final bool isSecondary;

  const FlavrButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.icon,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      height: 52,
      width: isFullWidth ? double.infinity : null,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isSecondary
                  ? null
                  : LinearGradient(
                      colors: isDisabled
                          ? [AppColors.textHint, AppColors.textHint]
                          : [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              color: isSecondary ? Colors.transparent : null,
              borderRadius: BorderRadius.circular(16),
              border: isSecondary
                  ? Border.all(
                      color: isDisabled ? AppColors.textHint : AppColors.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (leadingIcon != null) ...[
                          leadingIcon!,
                          const SizedBox(width: 8),
                        ] else if (icon != null) ...[
                          Icon(icon, size: 18, color: isSecondary ? AppColors.primary : Colors.white),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isSecondary
                                ? (isDisabled
                                    ? AppColors.textHint
                                    : AppColors.primary)
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
