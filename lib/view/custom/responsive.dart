import 'package:flutter/material.dart';

/// Width the mockups are drawn for (a ~390pt-wide phone).
const double kDesignWidth = 390;

/// Forms and text never grow wider than this on tablets / landscape.
const double kMaxContentWidth = 600;

/// Use as `MaterialApp(builder: responsiveBuilder)`.
///
/// Scales all text with the device's shortest side, so small phones get
/// slightly smaller text and tablets slightly larger, and keeps the user's
/// accessibility font size inside a range the layouts can handle.
Widget responsiveBuilder(BuildContext context, Widget? child) {
  final mq = MediaQuery.of(context);
  final deviceFactor = (mq.size.shortestSide / kDesignWidth).clamp(0.85, 1.15);
  final userFactor =
      mq.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.3).scale(14) /
      14;
  return MediaQuery(
    data: mq.copyWith(textScaler: TextScaler.linear(userFactor * deviceFactor)),
    child: child ?? const SizedBox.shrink(),
  );
}

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  bool get isTablet => screenSize.shortestSide >= 600;

  /// Landscape phones and other short screens (ignores the keyboard, so the
  /// layout doesn't flip while the user is typing).
  bool get isCompactHeight => screenSize.height < 600;
}

/// Extra horizontal padding that keeps content at most [kMaxContentWidth]
/// wide. Use this instead of [MaxWidthBox] inside `SliverFillRemaining`,
/// which measures intrinsic height and needs the real content width.
double contentSidePadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width > kMaxContentWidth ? (width - kMaxContentWidth) / 2 : 0;
}

/// Centres [child] and caps its width, so content doesn't stretch edge to
/// edge on tablets and in landscape.
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({
    super.key,
    required this.child,
    this.maxWidth = kMaxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
