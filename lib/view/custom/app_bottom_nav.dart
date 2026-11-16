import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/app_icon.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';

/// One tab of [AppBottomNav]: a PNG from `assets/images/{icon}.png` + label.
class AppNavItem {
  const AppNavItem({required this.icon, required this.label, this.showDot = false});

  final String icon;
  final String label;

  /// Small brown dot on the icon (e.g. unread messages in Inbox).
  final bool showDot;
}

/// Floating, rounded bottom navigation bar used by the dashboard shell.
///
/// Place it in `Scaffold.bottomNavigationBar`; it adds the device's bottom
/// safe-area inset itself and caps its width on tablets / landscape.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    // Not MaxWidthBox: its Center would expand to the full screen height
    // inside Scaffold.bottomNavigationBar. heightFactor: 1 keeps the bar
    // only as tall as its content.
    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1,
      child: Container(
        constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
        margin: EdgeInsets.fromLTRB(16, 4, 16, MediaQuery.paddingOf(context).bottom + 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.blueTintBorder),
          boxShadow: [
            BoxShadow(color: AppColors.navy.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _NavButton(
                  item: items[i],
                  selected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.selected, required this.onTap});

  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.brown : AppColors.textMuted;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
          decoration: BoxDecoration(
            color: selected ? AppColors.goldSoft : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: selected ? AppColors.goldBorder : Colors.transparent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AppIcon(item.icon, size: 24, color: color),
                  if (item.showDot)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(color: AppColors.brown, shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              // Labels shrink on narrow phones instead of wrapping.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.label,
                  maxLines: 1,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
