import 'package:flutter/material.dart';

/// Responsive grid that adapts column count based on screen width.
/// 
/// Breakpoints:
/// - Small screens (≤ 5.5"): 1 column
/// - Medium screens (5.5" - 6.7"): 2 columns
/// - Large screens (≥ 6.7"): 3 columns
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final double childAspectRatio;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.padding,
    this.childAspectRatio = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = _calculateCrossAxisCount(screenWidth);
        final spacing = _calculateSpacing(screenWidth);

        return GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          padding: padding,
          childAspectRatio: childAspectRatio,
          children: children,
        );
      },
    );
  }

  /// Calculate optimal column count based on screen width.
  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth <= 400) {
      return 1; // Small screens: 1 column
    } else if (screenWidth <= 600) {
      return 2; // Medium screens: 2 columns
    }
    return 3; // Large screens: 3 columns
  }

  /// Calculate adaptive spacing based on screen width.
  double _calculateSpacing(double screenWidth) {
    if (screenWidth <= 400) {
      return 12;
    } else if (screenWidth <= 600) {
      return 16;
    }
    return 20;
  }
}
