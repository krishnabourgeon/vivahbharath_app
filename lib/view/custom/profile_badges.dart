import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';

/// "Verified" and "Paid Member" pills shown above a member's name on profile
/// cards (Matches, Search results, Inbox, Activity, Profile detail).
///
/// Renders nothing when neither flag is set.
class ProfileBadges extends StatelessWidget {
  const ProfileBadges({
    super.key,
    this.verified = false,
    this.paid = false,
    this.compact = false,
  });

  final bool verified;
  final bool paid;

  /// Smaller text/icons for tight cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (!verified && !paid) return const SizedBox.shrink();
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        if (verified)
          _Pill(
            label: 'Verified',
            icon: Icons.verified_rounded,
            color: AppColors.verified,
            compact: compact,
          ),
        if (paid)
          _Pill(
            label: 'Paid Member',
            icon: Icons.workspace_premium_rounded,
            color: AppColors.purple,
            compact: compact,
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.icon,
    required this.color,
    required this.compact,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Container(
        padding: EdgeInsets.fromLTRB(4, compact ? 2 : 3, 8, compact ? 2 : 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: compact ? 13 : 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: compact ? 10.5 : 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small green outlined "Online" tag shown next to a member's name.
class OnlineBadge extends StatelessWidget {
  const OnlineBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Online',
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 1, 7, 1),
        decoration: BoxDecoration(
          color: AppColors.online.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.online),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'Online',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.verified,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gold "Featured Profile" tag that sits on the top edge of a featured card.
class FeaturedRibbon extends StatelessWidget {
  const FeaturedRibbon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 3, 10, 3),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            size: 13,
            color: AppColors.goldDark,
          ),
          SizedBox(width: 4),
          Text(
            'Featured Profile',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.goldDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card decoration shared by featured / normal profile cards.
BoxDecoration profileCardDecoration({required bool featured}) => BoxDecoration(
      color: featured ? null : Colors.white,
      gradient: featured
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.loginA, Colors.white],
              stops: [0, 0.45],
            )
          : null,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: featured ? AppColors.goldBorder : AppColors.blueTintBorder,
        width: featured ? 1.4 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.tealDark.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ],
    );

/// Wraps [card] with the [FeaturedRibbon] when [featured] is true.
Widget withFeaturedRibbon(Widget card, {required bool featured}) {
  if (!featured) return card;
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Padding(padding: const EdgeInsets.only(top: 10), child: card),
      const Positioned(top: 0, left: 14, child: FeaturedRibbon()),
    ],
  );
}
