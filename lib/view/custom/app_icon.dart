import 'package:flutter/material.dart';

/// PNG icon from `assets/images/{name}.png`, tinted with [color].
class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {super.key, this.size = 22, this.color});

  final String name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$name.png',
      // Logical pixels, so icons don't balloon on tablets / landscape.
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color == null ? null : BlendMode.srcIn,
      // A missing icon leaves an empty gap instead of an error box.
      errorBuilder: (_, _, _) => SizedBox(width: size, height: size),
    );
  }
}
