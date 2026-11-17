import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/model/privacy_settings_body.dart';
import 'package:vivahbharath_app/model/privacy_settings_model.dart' as privacy;
import 'package:vivahbharath_app/provider/home_provider.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
import 'package:vivahbharath_app/view/drawer/trust_badge.dart';

/// The four details a member can hide.
enum PrivacyItem {
  name('Name', 'Hide your name', Icons.badge_outlined, 'name'),
  photo('Photo', 'Hide your Profile Image', Icons.photo_camera_outlined, 'photo'),
  horoscope('Horoscope', 'Hide your Horoscope', Icons.auto_awesome_outlined, 'horoscope'),
  mobile('Mobile Number', 'Hide your Mobile Number', Icons.call_outlined, 'call');

  const PrivacyItem(this.label, this.hideLabel, this.icon, this.iconName);
  final String label;
  final String hideLabel;
  final IconData icon;
  final String iconName;
}

Set<PrivacyItem> _hiddenFrom(privacy.Data d) => {
      if (d.hideName) PrivacyItem.name,
      if (d.hidePhoto) PrivacyItem.photo,
      if (d.hideHoroscope) PrivacyItem.horoscope,
      if (d.hideMobile) PrivacyItem.mobile,
    };

PrivacySettingsBody _bodyFrom(Set<PrivacyItem> hidden) => PrivacySettingsBody(
      hideName: hidden.contains(PrivacyItem.name),
      hidePhoto: hidden.contains(PrivacyItem.photo),
      hideHoroscope: hidden.contains(PrivacyItem.horoscope),
      hideMobile: hidden.contains(PrivacyItem.mobile),
    );

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key, this.showBottomNav = true});

  final bool showBottomNav;

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  Set<PrivacyItem> _saved = {};
  Set<PrivacyItem> _draft = {};

  /// From the server; null until known. When false, horoscope can't be hidden.
  bool? _horoscopeAvailable;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // TODO: load from the server once a read endpoint exists (GET
    // privacy-settings returns 405). Until then, seed from the last saved
    // response this app session, else start with everything visible.
    final data = context.read<HomeProvider>().privacySettingsModel?.data;
    if (data != null) _apply(data);
  }

  void _apply(privacy.Data d) {
    _saved = _hiddenFrom(d);
    _draft = {..._saved};
    _horoscopeAvailable = d.horoscopeAvailable;
  }

  bool get _dirty =>
      _saved.length != _draft.length || !_saved.containsAll(_draft);

  void _toggle(PrivacyItem i, bool hide) =>
      setState(() => hide ? _draft.add(i) : _draft.remove(i));

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? AppColors.coral : AppColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(msg, style: const TextStyle(fontSize: 13)),
      ));
  }

  Future<void> _save() async {
    final provider = context.read<HomeProvider>();
    setState(() => _saving = true);
    final ok = await provider.privacySettings(_bodyFrom(_draft));
    if (!mounted) return;
    final model = provider.privacySettingsModel;
    setState(() {
      _saving = false;
      // The POST response carries the saved state; trust it over the draft.
      if (ok && model != null) _apply(model.data);
    });
    if (ok) {
      _snack(model?.message.isNotEmpty == true
          ? model!.message
          : 'Privacy settings saved');
    } else {
      _snack(provider.privacySettingsError ?? 'Could not save. Please try again',
          error: true);
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
              const SearchTopBar(title: 'Privacy Settings'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    const InfoHero(
                      title: 'Your privacy',
                      body:
                          'Protect your Name, Photo, Horoscope & Mobile Number from others, and make them visible only to members you prefer.',
                      icon: Icons.privacy_tip_outlined,
                      iconName: 'privacy_settings',
                    ),
                    const SizedBox(height: 14),

                    // Current status (the web's left panel)
                    _StatusSummary(hidden: _saved),
                    const SizedBox(height: 14),

                    // Toggles
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.blueTintBorder),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          for (var i = 0; i < PrivacyItem.values.length; i++) ...[
                            if (i > 0)
                              const Divider(
                                  height: 1,
                                  indent: 64,
                                  color: AppColors.blueTintBorder),
                            _ToggleRow(
                              item: PrivacyItem.values[i],
                              hidden: _draft.contains(PrivacyItem.values[i]),
                              onChanged: _saving ||
                                      (PrivacyItem.values[i] ==
                                              PrivacyItem.horoscope &&
                                          _horoscopeAvailable == false)
                                  ? null
                                  : (v) => _toggle(PrivacyItem.values[i], v),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
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
                              'Members can still ask to see hidden details. You decide who gets access from Inbox › Requests.',
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
                child: Opacity(
                  opacity: _dirty ? 1 : 0.55,
                  child: PillButton(
                    label: _saving ? 'Saving…' : 'Save',
                    icon: matchIcon(Icons.check_rounded, 'check',
                        size: 18, color: Colors.white),
                    foreground: Colors.white,
                    gradient: kTealGradient,
                    onTap: _dirty && !_saving ? _save : null,
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

class _StatusSummary extends StatelessWidget {
  const _StatusSummary({required this.hidden});
  final Set<PrivacyItem> hidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppColors.blueTint],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Who can see your details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (_, box) {
              final w = (box.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final i in PrivacyItem.values)
                    SizedBox(
                      width: w,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.blueTintBorder),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                i.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                            VisibilityPill(hidden: hidden.contains(i)),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.item,
    required this.hidden,
    required this.onChanged,
  });

  final PrivacyItem item;
  final bool hidden;

  /// Null disables the row (while saving, or horoscope with none uploaded).
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final accent = hidden ? AppColors.coral : AppColors.tealMid;
    return MergeSemantics(
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(!hidden),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: matchIcon(item.icon, item.iconName,
                    size: 20, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.hideLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hidden
                          ? 'Only members you approve can see it'
                          : 'Visible to all members',
                      style: TextStyle(
                        fontSize: 12,
                        color: hidden ? AppColors.coral : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: hidden,
                onChanged: onChanged,
                activeTrackColor: AppColors.coral,
                inactiveTrackColor: AppColors.blueTint,
                trackOutlineColor:
                    const WidgetStatePropertyAll(Colors.transparent),
                thumbColor: const WidgetStatePropertyAll(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small "Visible" / "Hidden" pill.
class VisibilityPill extends StatelessWidget {
  const VisibilityPill({super.key, required this.hidden});
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final fg = hidden ? AppColors.coral : AppColors.verified;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        hidden ? 'Hidden' : 'Visible',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}