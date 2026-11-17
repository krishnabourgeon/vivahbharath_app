import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
import 'package:vivahbharath_app/view/drawer/manage_photo_screen.dart';


enum BadgeStatus {
  notVerified('Not verified'),
  pending('Under review'),
  verified('Verified'),
  rejected('Not approved');

  const BadgeStatus(this.label);
  final String label;
}

/// A file the user picked.
class PickedDoc {
  const PickedDoc(this.name, this.sizeBytes, {this.path});
  final String name;
  final int sizeBytes;
  final String? path;

  String get sizeLabel => sizeBytes >= 1024 * 1024
      ? '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
      : '${(sizeBytes / 1024).ceil()} KB';
}

/// Return the picked file, e.g. with the file_picker package:
///
/// ```dart
/// onPickFile: () async {
///   final r = await FilePicker.platform.pickFiles(
///       type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
///   final f = r?.files.single;
///   return f == null ? null : PickedDoc(f.name, f.size, path: f.path);
/// }
/// ```
typedef DocPicker = Future<PickedDoc?> Function();

class TrustBadgeDef {
  const TrustBadgeDef({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconName,
    required this.accent,
    required this.tint,
    required this.docs,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final String iconName;
  final Color accent;
  final Color tint;
  final List<String> docs;
}

const kTrustBadges = [
  TrustBadgeDef(
    title: 'Identity Badge',
    subtitle: 'Lets members trust your age, name and date of birth.',
    icon: Icons.badge_outlined,
    iconName: 'id',
    accent: AppColors.link,
    tint: AppColors.blueTint,
    docs: ['Driving License', 'PAN Card', 'Passport', 'Voter ID', 'Aadhaar Card'],
  ),
  TrustBadgeDef(
    title: 'Qualification Badge',
    subtitle: 'Lets members trust your education details.',
    icon: Icons.school_outlined,
    iconName: 'education',
    accent: AppColors.brown,
    tint: AppColors.cream,
    docs: ['Education Certificate'],
  ),
  TrustBadgeDef(
    title: 'Professional Badge',
    subtitle: 'Lets members trust your profession.',
    icon: Icons.work_outline_rounded,
    iconName: 'work',
    accent: AppColors.purple,
    tint: Color(0xFFF1EEF9),
    docs: ['Salary Slip'],
  ),
];

const _maxBytes = 2 * 1024 * 1024;
const _allowedExt = ['jpg', 'jpeg', 'png', 'pdf'];

class TrustBadgeScreen extends StatefulWidget {
  const TrustBadgeScreen({
    super.key,
    this.statuses = const [
      BadgeStatus.notVerified,
      BadgeStatus.notVerified,
      BadgeStatus.notVerified,
    ],
    this.onPickFile,
    this.onSubmit,
    this.showBottomNav = true,
  });

  /// One status per badge in [kTrustBadges].
  final List<BadgeStatus> statuses;
  final DocPicker? onPickFile;

  /// Upload the document. TODO: call your API.
  final Future<void> Function(int badge, String docType, PickedDoc file)?
      onSubmit;
  final bool showBottomNav;

  @override
  State<TrustBadgeScreen> createState() => _TrustBadgeScreenState();
}

class _BadgeState {
  _BadgeState(this.status, this.docType);
  BadgeStatus status;
  String? docType;
  PickedDoc? file;
  bool busy = false;
}

class _TrustBadgeScreenState extends State<TrustBadgeScreen> {
  late final List<_BadgeState> _s = [
    for (var i = 0; i < kTrustBadges.length; i++)
      _BadgeState(
        i < widget.statuses.length ? widget.statuses[i] : BadgeStatus.notVerified,
        kTrustBadges[i].docs.length == 1 ? kTrustBadges[i].docs.first : null,
      ),
  ];

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(msg, style: const TextStyle(fontSize: 13)),
      ));
  }

  Future<void> _pick(int i) async {
    if (widget.onPickFile == null) {
      _snack('Connect a file picker with onPickFile');
      return;
    }
    final f = await widget.onPickFile!();
    if (f == null || !mounted) return;
    final ext = f.name.contains('.') ? f.name.split('.').last.toLowerCase() : '';
    if (!_allowedExt.contains(ext)) {
      _snack('Use a JPG, JPEG, PNG or PDF file');
      return;
    }
    if (f.sizeBytes > _maxBytes) {
      _snack('File is larger than 2 MB');
      return;
    }
    setState(() => _s[i].file = f);
  }

  Future<void> _send(int i) async {
    final s = _s[i];
    if (s.docType == null) {
      _snack('Choose which document you are sending');
      return;
    }
    if (s.file == null) return;
    setState(() => s.busy = true);
    try {
      await widget.onSubmit?.call(i, s.docType!, s.file!);
      if (!mounted) return;
      setState(() {
        s.status = BadgeStatus.pending;
        s.file = null;
      });
      _snack('Sent for verification');
    } finally {
      if (mounted) setState(() => s.busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBottom,
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
              const SearchTopBar(title: 'Trust Badge'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    const InfoHero(
                      title: 'Trust Badge',
                      body:
                          'Your safety is our priority. To ensure a secure and positive experience, please follow these guidelines.',
                      icon: Icons.verified_user_rounded,
                      iconName: 'shield',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.blueTintBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          matchIcon(Icons.lock_outline_rounded, 'lock',
                              size: 18, color: AppColors.tealMid),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text.rich(
                              TextSpan(
                                text:
                                    'Documents are highly secure and stored for a maximum of six months. Supported formats: ',
                                children: [
                                  TextSpan(
                                    text: 'JPG, JPEG, PNG, PDF',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(text: ' · Max '),
                                  TextSpan(
                                    text: '2 MB',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                  fontSize: 12.5,
                                  height: 1.4,
                                  color: AppColors.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    for (var i = 0; i < kTrustBadges.length; i++) ...[
                      _BadgeCard(
                        def: kTrustBadges[i],
                        state: _s[i],
                        onPickDoc: (d) => setState(() => _s[i].docType = d),
                        onChooseFile: () => _pick(i),
                        onClearFile: () => setState(() => _s[i].file = null),
                        onSend: () => _send(i),
                        onResubmit: () => setState(
                            () => _s[i].status = BadgeStatus.notVerified),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({
    required this.def,
    required this.state,
    required this.onPickDoc,
    required this.onChooseFile,
    required this.onClearFile,
    required this.onSend,
    required this.onResubmit,
  });

  final TrustBadgeDef def;
  final _BadgeState state;
  final ValueChanged<String> onPickDoc;
  final VoidCallback onChooseFile;
  final VoidCallback onClearFile;
  final VoidCallback onSend;
  final VoidCallback onResubmit;

  @override
  Widget build(BuildContext context) {
    final canUpload = state.status == BadgeStatus.notVerified ||
        state.status == BadgeStatus.rejected;
    final ready = state.file != null && state.docType != null && !state.busy;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, def.tint],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: def.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: matchIcon(def.icon, def.iconName,
                    size: 21, color: def.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(def.title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 2),
                    Text(def.subtitle,
                        style: const TextStyle(
                            fontSize: 12.5, color: AppColors.textMuted)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusPill(state.status),
            ],
          ),
          const SizedBox(height: 14),

          if (state.status == BadgeStatus.verified)
            _Note(
              icon: Icons.check_circle_rounded,
              color: AppColors.verified,
              text: 'Verified. Members now see this badge on your profile.',
            )
          else if (state.status == BadgeStatus.pending)
            _Note(
              icon: Icons.schedule_rounded,
              color: AppColors.goldDark,
              text:
                  "We're checking your document. We'll let you know once it's reviewed.",
            )
          else ...[
            if (state.status == BadgeStatus.rejected) ...[
              _Note(
                icon: Icons.error_outline_rounded,
                color: AppColors.coral,
                text:
                    "We couldn't verify the last document. Please send a clear copy.",
              ),
              const SizedBox(height: 12),
            ],
            Text(
              def.docs.length > 1
                  ? 'Send any one of these documents'
                  : 'Send your',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final d in def.docs)
                  _DocChip(
                    label: d,
                    selected: d == state.docType,
                    onTap: () => onPickDoc(d),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _FileBox(
              file: state.file,
              onChoose: onChooseFile,
              onClear: onClearFile,
            ),
            const SizedBox(height: 12),
            Opacity(
              opacity: ready ? 1 : 0.55,
              child: PillButton(
                label: state.busy ? 'Sending…' : 'Send for verification',
                icon: matchIcon(Icons.send_rounded, 'send',
                    size: 16,
                    color: ready ? Colors.white : AppColors.textMuted),
                foreground: ready ? Colors.white : AppColors.textMuted,
                gradient: ready ? kTealGradient : null,
                background: ready ? null : AppColors.bgTop,
                onTap: ready && canUpload ? onSend : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill(this.status);
  final BadgeStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      BadgeStatus.verified => (
          AppColors.verified.withValues(alpha: 0.12),
          AppColors.verified
        ),
      BadgeStatus.pending => (AppColors.toggleBg, AppColors.goldDark),
      BadgeStatus.rejected => (
          AppColors.coral.withValues(alpha: 0.1),
          AppColors.coral
        ),
      BadgeStatus.notVerified => (AppColors.bgTop, AppColors.textMuted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(status.label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _DocChip extends StatelessWidget {
  const _DocChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.goldDark;
    return Semantics(
      selected: selected,
      child: Material(
        color: selected ? AppColors.tealMid : AppColors.loginA,
        shape: StadiumBorder(
          side: BorderSide(
              color: selected ? AppColors.tealMid : AppColors.goldBorder),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                matchIcon(
                    selected
                        ? Icons.check_rounded
                        : Icons.description_outlined,
                    'doc',
                    size: 15,
                    color: fg),
                const SizedBox(width: 5),
                Text(label,
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: fg)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FileBox extends StatelessWidget {
  const _FileBox({
    required this.file,
    required this.onChoose,
    required this.onClear,
  });
  final PickedDoc? file;
  final VoidCallback onChoose;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.tealMid),
        ),
        child: Row(
          children: [
            matchIcon(
                file!.name.toLowerCase().endsWith('.pdf')
                    ? Icons.picture_as_pdf_outlined
                    : Icons.image_outlined,
                'file',
                size: 22,
                color: AppColors.tealMid),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(file!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy)),
                  Text(file!.sizeLabel,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Remove file',
              onPressed: onClear,
              icon: matchIcon(Icons.close_rounded, 'close',
                  size: 20, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Semantics(
      button: true,
      label: 'Choose file',
      child: CustomPaint(
        foregroundPainter:
            const DashedRRectPainter(color: AppColors.fieldBorder, radius: 16),
        child: Material(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onChoose,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                children: [
                  matchIcon(Icons.upload_rounded, 'upload',
                      size: 24, color: AppColors.tealMid),
                  const SizedBox(height: 4),
                  const Text('Choose file',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tealMid)),
                  const Text('No file chosen',
                      style:
                          TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.color, required this.text});
  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          matchIcon(icon, 'status', size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 13, height: 1.4, color: color)),
          ),
        ],
      ),
    );
  }
}

/// Teal intro card with a large icon (used by Trust Badge and Safe Matrimony).
class InfoHero extends StatelessWidget {
  const InfoHero({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
    required this.iconName,
  });

  final String title;
  final String body;
  final IconData icon;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealB, AppColors.tealC],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.sparkleGold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: matchIcon(icon, iconName,
                size: 44, color: AppColors.sparkleGold),
          ),
        ],
      ),
    );
  }
}