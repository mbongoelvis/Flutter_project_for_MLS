import 'package:flutter/material.dart';
import 'package:flavr/core/theme/app_colors.dart';

class FlavrScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showBackButton;
  final Color? backgroundColor;
  final PreferredSizeWidget? customAppBar;
  final bool extendBodyBehindAppBar;

  const FlavrScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showBackButton = true,
    this.backgroundColor,
    this.customAppBar,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: customAppBar ??
          (title != null
              ? AppBar(
                  title: Text(
                    title!,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  backgroundColor: backgroundColor ?? AppColors.background,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  centerTitle: true,
                  automaticallyImplyLeading: showBackButton,
                  iconTheme: const IconThemeData(color: AppColors.textPrimary),
                  actions: actions,
                )
              : null),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
