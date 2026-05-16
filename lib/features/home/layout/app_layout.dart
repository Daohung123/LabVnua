import 'package:flutter/material.dart';
import 'package:aqedu/core/theme/app_theme.dart';

/// AppLayout — a reusable, responsive scaffold wrapper for screens.
///
/// Usage:
/// AppLayout(
///   appBar: HomeAppBar(),
///   child: ListView(...),
/// );
class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    this.appBar,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: padding ?? AppSpacing.screenPadding,
          child: Builder(
            builder: (_) {
              // If the child is a ScrollView already (ListView/GridView), return as-is.
              // Otherwise wrap in SingleChildScrollView to provide scrolling when needed.
              if (child is ScrollView) return child;
              return SingleChildScrollView(child: child);
            },
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
