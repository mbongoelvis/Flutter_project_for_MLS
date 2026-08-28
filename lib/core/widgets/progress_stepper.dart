import 'package:flutter/material.dart';
import 'package:flavr/core/theme/app_colors.dart';

class ProgressStepper extends StatefulWidget {
  /// Current step index, 0-based.
  final int currentStep;

  /// Total number of steps.
  final int totalSteps;

  const ProgressStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  State<ProgressStepper> createState() => _ProgressStepperState();
}

class _ProgressStepperState extends State<ProgressStepper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.totalSteps, (index) {
        final isCompleted = index < widget.currentStep;
        final isCurrent = index == widget.currentStep;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: isCurrent
              ? AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (_, __) => Transform.scale(
                    scale: _pulseAnimation.value,
                    child: _Dot(
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isCompleted ? 24 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.textHint.withOpacity(0.35),
                  ),
                ),
        );
      }),
    );
  }
}

class _Dot extends StatelessWidget {
  final double size;
  final Color color;

  const _Dot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.45),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
