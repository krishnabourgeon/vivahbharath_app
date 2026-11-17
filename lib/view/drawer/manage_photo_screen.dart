import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';

/// One photo slot (Profile photo, Close-Up, Full length …).
class PhotoSlot {
  PhotoSlot(this.label, {this.image, this.filled = false});
  final String label;

  /// The picked / uploaded image. If [filled] is true and this is null, the
  /// illustrated avatar is shown (sample data).
  ImageProvider? image;
  bool filled;
}

const kPhotoSlotLabels = [
  'Profile photo',
  'Close-Up',
  'Full length',
  'Traditional',
  'Candid',
  'Professional',
  'Casual',
  'Formal',
];

/// Return the picked image, e.g. with the image_picker package:
///
/// ```dart
/// onPick: (slot) async {
///   final x = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
///   return x == null ? null : FileImage(File(x.path));
/// }
/// ```
typedef PhotoPicker = Future<ImageProvider?> Function(String slotLabel);

List<PhotoSlot> samplePhotoSlots() => [
      for (final l in kPhotoSlotLabels)
        PhotoSlot(l, filled: l == 'Profile photo' || l == 'Full length'),
    ];

class ManagePhotosScreen extends StatefulWidget {
  const ManagePhotosScreen({
    super.key,
    this.name = 'Priyesh',
    this.slots,
    this.onPick,
    this.onSave,
    this.showBottomNav = true,
  });

  final String name;
  final List<PhotoSlot>? slots;
  final PhotoPicker? onPick;

  /// TODO: upload changed slots to your API.
  final Future<void> Function(List<PhotoSlot> slots)? onSave;
  final bool showBottomNav;

  @override
  State<ManagePhotosScreen> createState() => _ManagePhotosScreenState();
}

class _ManagePhotosScreenState extends State<ManagePhotosScreen> {
  late final List<PhotoSlot> _slots = widget.slots ?? samplePhotoSlots();
  bool _saving = false;

  int get _filled => _slots.where((s) => s.filled).length;

  void _snack(String msg, {VoidCallback? onUndo}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(msg, style: const TextStyle(fontSize: 13)),
        action: onUndo == null
            ? null
            : SnackBarAction(
                label: 'Undo',
                textColor: AppColors.goldBorder,
                onPressed: onUndo),
      ));
  }

  Future<void> _pick(int i) async {
    if (widget.onPick == null) {
      _snack('Connect a photo picker with onPick');
      return;
    }
    final img = await widget.onPick!(_slots[i].label);
    if (img == null || !mounted) return;
    setState(() {
      _slots[i].image = img;
      _slots[i].filled = true;
    });
  }

  void _remove(int i) {
    final s = _slots[i];
    final (img, filled) = (s.image, s.filled);
    setState(() {
      s.image = null;
      s.filled = false;
    });
    _snack('${s.label} removed', onUndo: () => setState(() {
          s.image = img;
          s.filled = filled;
        }));
  }

  void _makeProfile(int i) {
    final a = _slots[0], b = _slots[i];
    setState(() {
      final (img, filled) = (a.image, a.filled);
      a.image = b.image;
      a.filled = b.filled;
      b.image = img;
      b.filled = filled;
    });
    _snack('Profile photo updated');
  }

  Future<void> _options(int i) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.fieldBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _slots[i].label,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              if (i != 0)
                _SheetAction(Icons.account_circle_outlined, 'Set as profile photo',
                    () => Navigator.pop(ctx, 'profile')),
              _SheetAction(Icons.swap_horiz_rounded, 'Replace photo',
                  () => Navigator.pop(ctx, 'replace')),
              _SheetAction(Icons.delete_outline_rounded, 'Remove photo',
                  () => Navigator.pop(ctx, 'remove'),
                  danger: true),
            ],
          ),
        ),
      ),
    );
    switch (action) {
      case 'profile':
        _makeProfile(i);
      case 'replace':
        await _pick(i);
      case 'remove':
        _remove(i);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.onSave?.call(_slots);
      if (mounted) _snack('Photos saved');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      // bottomNavigationBar:
      //     widget.showBottomNav ? const AppBottomNav(currentIndex: 4) : null,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom],
            stops: [0, 0.4],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SearchTopBar(title: 'Manage your Photos'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    _Header(
                      name: widget.name,
                      slot: _slots[0],
                      onChange: () => _pick(0),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Your photos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        Text(
                          '$_filled of ${_slots.length} added',
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _slots.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (_, i) => _PhotoTile(
                        slot: _slots[i],
                        isProfile: i == 0,
                        tint: _tints[i % _tints.length],
                        onTap: () =>
                            _slots[i].filled ? _options(i) : _pick(i),
                        onRemove: () => _remove(i),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.goldBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          matchIcon(Icons.info_outline_rounded, 'info',
                              size: 16, color: AppColors.goldDark),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Clear, recent photos with your face visible get more responses. '
                              'Photos are watermarked to protect your privacy.',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  height: 1.4,
                                  color: AppColors.goldDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(top: BorderSide(color: AppColors.blueTintBorder)),
                ),
                child: PillButton(
                  label: _saving ? 'Saving…' : 'Save',
                  icon: const SizedBox.shrink(),
                  foreground: Colors.white,
                  gradient: kTealGradient,
                  onTap: _saving ? null : _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _tints = [
  AppColors.cream,
  AppColors.blueTint,
  Color(0xFFF1EEF9), // soft purple
  Color(0xFFFBF0EE), // soft coral
];

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.slot, required this.onChange});
  final String name;
  final PhotoSlot slot;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealB, AppColors.tealC],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: matchIcon(Icons.photo_camera_outlined, 'camera',
                size: 56, color: Colors.white.withValues(alpha: 0.12)),
          ),
          Row(
            children: [
              Container(
                width: 84,
                height: 92,
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: _SlotImage(slot: slot),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 17,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PillButton(
                      label: 'Change Profile Photo',
                      icon: matchIcon(Icons.edit_outlined, 'edit',
                          size: 16, color: AppColors.goldDark),
                      foreground: AppColors.goldDark,
                      gradient: const LinearGradient(
                          colors: [AppColors.loginA, AppColors.loginB]),
                      borderColor: AppColors.goldBorder,
                      onTap: onChange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlotImage extends StatelessWidget {
  const _SlotImage({required this.slot});
  final PhotoSlot slot;

  @override
  Widget build(BuildContext context) {
    if (slot.image != null) {
      return Image(image: slot.image!, fit: BoxFit.cover);
    }
    if (slot.filled) return const CustomPaint(painter: AvatarPainter());
    return Center(
      child: matchIcon(Icons.person_outline_rounded, 'person',
          size: 36, color: AppColors.hint),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.slot,
    required this.isProfile,
    required this.tint,
    required this.onTap,
    required this.onRemove,
  });

  final PhotoSlot slot;
  final bool isProfile;
  final Color tint;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(18);

    if (!slot.filled) {
      return Semantics(
        button: true,
        label: 'Add ${slot.label}',
        child: CustomPaint(
          foregroundPainter: DashedRRectPainter(
              color: AppColors.fieldBorder, radius: 18),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: r,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, tint],
                ),
              ),
              child: InkWell(
                borderRadius: r,
                onTap: onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tealDark.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: matchIcon(Icons.add_rounded, 'add',
                            size: 24, color: AppColors.tealMid),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      slot.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text('Tap to add',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Semantics(
      button: true,
      label: '${slot.label}, options',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: r,
          border: Border.all(
            color: isProfile ? AppColors.marigoldO : AppColors.blueTintBorder,
            width: isProfile ? 2 : 1,
          ),
          color: AppColors.blueTint,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _SlotImage(slot: slot),
            // Bottom label
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 18, 10, 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.navy.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                child: Text(
                  slot.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(onTap: onTap),
            ),
            if (isProfile)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.goldSoft,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.goldBorder),
                  ),
                  child: const Text(
                    'Profile photo',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.goldDark,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 6,
              right: 6,
              child: Material(
                color: AppColors.coral,
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.white, width: 2)),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onRemove,
                  child: Tooltip(
                    message: 'Remove ${slot.label}',
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: matchIcon(Icons.close_rounded, 'close',
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction(this.icon, this.label, this.onTap, {this.danger = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final c = danger ? AppColors.coral : AppColors.navy;
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: matchIcon(icon, label.toLowerCase(), size: 22, color: c),
      title: Text(label,
          style:
              TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c)),
      onTap: onTap,
    );
  }
}

/// Dashed rounded border (used for empty photo slots and file drop boxes).
class DashedRRectPainter extends CustomPainter {
  const DashedRRectPainter({
    required this.color,
    this.radius = 16,
    this.strokeWidth = 1.4,
    this.dash = 6,
    this.gap = 4,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          rect.deflate(strokeWidth / 2), Radius.circular(radius)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (final ui.PathMetric m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedRRectPainter old) =>
      old.color != color || old.radius != radius;
}