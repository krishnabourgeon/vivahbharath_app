import 'package:flutter/material.dart';
import 'package:vivahbharath_app/model/view_request.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';

/// Icon for each kind of privacy request.
IconData requestIcon(ViewRequestType t) => switch (t) {
  ViewRequestType.name => Icons.badge_outlined,
  ViewRequestType.photo => Icons.photo_camera_outlined,
  ViewRequestType.horoscope => Icons.auto_awesome_outlined,
  ViewRequestType.mobile => Icons.call_outlined,
};

/// "Awaiting Response" dialog shown when the viewer taps a request that is
/// already pending.
Future<void> showRequestPendingDialog(
  BuildContext context,
  ViewRequestType type,
) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.toggleBg,
        ),
        child: matchIcon(
          Icons.schedule_rounded,
          'clock',
          size: 32,
          color: AppColors.goldDark,
        ),
      ),
      title: const Text(
        'Awaiting Response',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
      content: Text(
        'Your request to view this ${type.noun} is still awaiting a response.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: 120,
          child: PillButton(
            label: 'OK',
            icon: const SizedBox.shrink(),
            foreground: Colors.white,
            gradient: kTealGradient,
            onTap: () => Navigator.of(ctx).pop(),
          ),
        ),
      ],
    ),
  );
}

/// Asks "Send a request to view this member's name?" before sending a
/// request from a small control (where a mis-tap is likely).
Future<bool> confirmViewRequest(BuildContext context, ViewRequestType type) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Request ${type.label.toLowerCase()}?',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
      content: Text(
        'This member has hidden their ${type.noun}. Send a request to view it?',
        style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.tealMid),
          child: const Text(
            'Send request',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
  return ok ?? false;
}

/// Eye-off icon shown next to a hidden name. Tapping it asks to send a name
/// request, or shows "Awaiting Response" when one is already pending.
class HiddenNameButton extends StatelessWidget {
  const HiddenNameButton({
    super.key,
    required this.requested,
    required this.onRequest,
    this.busy = false,
    this.size = 16,
  });

  final bool requested;
  final bool busy;
  final VoidCallback onRequest;
  final double size;

  @override
  Widget build(BuildContext context) {
    const type = ViewRequestType.name;
    return Semantics(
      button: true,
      label: requested ? 'Name request awaiting response' : 'Request name',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: busy
            ? null
            : () async {
                if (requested) {
                  showRequestPendingDialog(context, type);
                } else if (await confirmViewRequest(context, type)) {
                  onRequest();
                }
              },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: busy
              ? SizedBox(
                  width: size - 2,
                  height: size - 2,
                  child: const CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: AppColors.coral,
                  ),
                )
              : matchIcon(
                  requested
                      ? Icons.schedule_rounded
                      : Icons.visibility_off_outlined,
                  requested ? 'clock' : 'eye_off',
                  size: size,
                  color: requested ? AppColors.goldDark : AppColors.coral,
                ),
        ),
      ),
    );
  }
}

/// Full-width "Request Photo / Name / Horoscope / Number" button.
///
/// Shows a spinner while [busy], and "Awaiting Response" (tap → dialog)
/// once [requested].
class RequestAccessButton extends StatelessWidget {
  const RequestAccessButton({
    super.key,
    required this.type,
    required this.requested,
    required this.onRequest,
    this.busy = false,
  });

  final ViewRequestType type;
  final bool requested;
  final bool busy;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    if (requested) {
      return PillButton(
        label: 'Awaiting Response',
        icon: matchIcon(
          Icons.schedule_rounded,
          'clock',
          size: 16,
          color: AppColors.goldDark,
        ),
        foreground: AppColors.goldDark,
        background: AppColors.toggleBg,
        onTap: () => showRequestPendingDialog(context, type),
      );
    }
    return PillButton(
      label: busy ? 'Sending request…' : 'Request ${type.label}',
      icon: busy
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : matchIcon(
              requestIcon(type),
              type.apiValue,
              size: 16,
              color: Colors.white,
            ),
      foreground: Colors.white,
      gradient: kTealGradient,
      onTap: busy ? null : onRequest,
    );
  }
}

/// Small dark capsule for tight spots (photo overlays on match cards).
class RequestAccessChip extends StatelessWidget {
  const RequestAccessChip({
    super.key,
    required this.type,
    required this.requested,
    required this.onRequest,
    this.busy = false,
  });

  final ViewRequestType type;
  final bool requested;
  final bool busy;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final label = requested
        ? 'Awaiting Response'
        : (busy ? 'Sending…' : 'Request ${type.label}');
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.navy.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: busy
              ? null
              : (requested
                    ? () => showRequestPendingDialog(context, type)
                    : onRequest),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: Row(
              children: [
                if (busy)
                  const SizedBox(
                    width: 11,
                    height: 11,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.6,
                      color: Colors.white,
                    ),
                  )
                else
                  matchIcon(
                    requested ? Icons.schedule_rounded : requestIcon(type),
                    type.apiValue,
                    size: 12,
                    color: Colors.white,
                  ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Body for a profile section the viewer can't see yet: a lock, a short
/// note and a [RequestAccessButton].
class LockedSectionBody extends StatelessWidget {
  const LockedSectionBody({
    super.key,
    required this.type,
    required this.message,
    required this.requested,
    required this.onRequest,
    this.busy = false,
  });

  final ViewRequestType type;
  final String message;
  final bool requested;
  final bool busy;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              matchIcon(
                Icons.lock_outline_rounded,
                'lock',
                size: 18,
                color: AppColors.goldDark,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RequestAccessButton(
            type: type,
            requested: requested,
            busy: busy,
            onRequest: onRequest,
          ),
        ],
      ),
    );
  }
}
