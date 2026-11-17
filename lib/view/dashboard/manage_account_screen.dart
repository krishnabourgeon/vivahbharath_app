import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';


/// Manage Account: Change Password / Delete Account.
class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({
    super.key,
    this.initialTab = 0,
    this.showBottomNav = true,
    this.onPasswordChanged,
    this.onDeleteAccount,
    this.onHideProfile,
    this.onForgotPassword,
  });

  /// 0 = Change Password, 1 = Delete Account.
  final int initialTab;
  final bool showBottomNav;

  /// Called with (current, new). TODO: call your API.
  final Future<void> Function(String current, String next)? onPasswordChanged;

  /// Called with (password, reason). TODO: call your API, then log out.
  final Future<void> Function(String password, String? reason)? onDeleteAccount;
  final VoidCallback? onHideProfile;
  final VoidCallback? onForgotPassword;

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  late int _tab = widget.initialTab;

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
              const SearchTopBar(title: 'Manage Account'),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  'Update your password or permanently delete your account',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _TabButton(
                        label: 'Change Password',
                        selected: _tab == 0,
                        onTap: () => setState(() => _tab = 0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _TabButton(
                        label: 'Delete Account',
                        selected: _tab == 1,
                        danger: true,
                        onTap: () => setState(() => _tab = 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: _tab == 0
                    ? _ChangePassword(
                        onSubmit: widget.onPasswordChanged,
                        onForgot: widget.onForgotPassword,
                      )
                    : _DeleteAccount(
                        onDelete: widget.onDeleteAccount,
                        onHide: widget.onHideProfile,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final bool selected;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.coral : AppColors.tealMid;
    return Semantics(
      selected: selected,
      child: PillButton(
        label: label,
        icon: const SizedBox.shrink(),
        foreground: selected ? Colors.white : color,
        background: selected ? color : Colors.white,
        gradient: selected && !danger ? kTealGradient : null,
        borderColor: selected ? null : color.withValues(alpha: 0.5),
        onTap: onTap,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Change password
// ─────────────────────────────────────────────────────────────────────────────
class _ChangePassword extends StatefulWidget {
  const _ChangePassword({this.onSubmit, this.onForgot});
  final Future<void> Function(String current, String next)? onSubmit;
  final VoidCallback? onForgot;

  @override
  State<_ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<_ChangePassword> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  bool _tried = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_current, _next, _confirm]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String get _n => _next.text;
  bool get _len => _n.length >= 8;
  bool get _upper => RegExp(r'[A-Z]').hasMatch(_n);
  bool get _num => RegExp(r'\d').hasMatch(_n);
  bool get _special => RegExp(r'[^A-Za-z0-9]').hasMatch(_n);
  bool get _strong => _len && _upper && _num && _special;
  bool get _matches => _confirm.text.isNotEmpty && _confirm.text == _n;
  bool get _valid => _current.text.isNotEmpty && _strong && _matches;

  Future<void> _submit() async {
    setState(() => _tried = true);
    if (!_valid) return;
    setState(() => _busy = true);
    try {
      await widget.onSubmit?.call(_current.text, _n);
      if (!mounted) return;
      _current.clear();
      _next.clear();
      _confirm.clear();
      _tried = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        content: Text('Password updated'),
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        _Card(
          children: [
            const Text(
              'Update Password',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Minimum 8 characters, including an uppercase letter, a number and a special character',
              style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            PasswordField(
              label: 'Current Password',
              controller: _current,
              error: _tried && _current.text.isEmpty
                  ? 'Enter your current password'
                  : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onForgot ?? () {/* TODO */},
                style: TextButton.styleFrom(foregroundColor: AppColors.link),
                child: const Text('Forgot current password?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            PasswordField(label: 'New Password', controller: _next),
            const SizedBox(height: 10),
            if (_n.isNotEmpty) _StrengthBar(score: [_len, _upper, _num, _special].where((b) => b).length),
            const SizedBox(height: 8),
            _Rule('At least 8 characters', _len),
            _Rule('Includes an uppercase letter', _upper),
            _Rule('Includes a number', _num),
            _Rule('Includes a special character', _special),
            const SizedBox(height: 14),
            PasswordField(
              label: 'Confirm New Password',
              controller: _confirm,
              error: _confirm.text.isNotEmpty && !_matches
                  ? "Passwords don't match"
                  : (_tried && _confirm.text.isEmpty
                      ? 'Confirm your new password'
                      : null),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                matchIcon(Icons.info_outline_rounded, 'info',
                    size: 16, color: AppColors.textMuted),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    "You'll stay logged in on this phone. Other devices will be logged out.",
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PillButton(
              label: _busy ? 'Updating…' : 'Update Password',
              icon: matchIcon(Icons.lock_reset_rounded, 'lock',
                  size: 18, color: Colors.white),
              foreground: Colors.white,
              gradient: kTealGradient,
              onTap: _busy ? null : _submit,
            ),
          ],
        ),
      ],
    );
  }
}

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.score});
  final int score; // 0–4

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (score) {
      <= 1 => ('Weak password', AppColors.coral),
      2 || 3 => ('Fair password', AppColors.marigoldO),
      _ => ('Strong password', AppColors.verified),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < 4; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: i < score ? color : AppColors.blueTint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule(this.text, this.ok);
  final String text;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          matchIcon(
            ok ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            'check',
            size: 16,
            color: ok ? AppColors.verified : AppColors.hint,
          ),
          const SizedBox(width: 6),
          Text(text,
              style: TextStyle(
                  fontSize: 12.5,
                  color: ok ? AppColors.verified : AppColors.textMuted)),
        ],
      ),
    );
  }
}

/// Password field with a show / hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.error,
  });

  final String label;
  final TextEditingController controller;
  final String? error;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder b(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ),
        TextField(
          controller: widget.controller,
          obscureText: _hidden,
          enableSuggestions: false,
          autocorrect: false,
          style: const TextStyle(fontSize: 14, color: AppColors.navy),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            errorText: widget.error,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: b(AppColors.fieldBorder),
            enabledBorder: b(AppColors.fieldBorder),
            focusedBorder: b(AppColors.tealMid, 1.4),
            errorBorder: b(AppColors.coral),
            focusedErrorBorder: b(AppColors.coral, 1.4),
            suffixIcon: IconButton(
              tooltip: _hidden ? 'Show password' : 'Hide password',
              onPressed: () => setState(() => _hidden = !_hidden),
              icon: matchIcon(
                _hidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                _hidden ? 'eye_off' : 'eye',
                size: 20,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Delete account
// ─────────────────────────────────────────────────────────────────────────────
class _DeleteAccount extends StatefulWidget {
  const _DeleteAccount({this.onDelete, this.onHide});
  final Future<void> Function(String password, String? reason)? onDelete;
  final VoidCallback? onHide;

  @override
  State<_DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<_DeleteAccount> {
  static const _reasons = [
    'I found my match on Vivah Bharath',
    'I found my match elsewhere',
    'Not getting relevant matches',
    'Privacy concerns',
    'Too many calls or messages',
    'Other',
  ];

  final _password = TextEditingController();
  String? _reason;
  bool _understood = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  bool get _canDelete =>
      _password.text.isNotEmpty && _understood && !_busy;

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete your account?',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navy)),
        content: const Text(
          'Your profile and all its data will be permanently deleted. This can’t be undone.',
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep account',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await widget.onDelete?.call(_password.text, _reason);
      // TODO: clear session and go to the welcome screen.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        // Warning
        _Card(
          tint: AppColors.coral.withValues(alpha: 0.06),
          border: AppColors.coral.withValues(alpha: 0.3),
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.coral.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: matchIcon(Icons.warning_amber_rounded, 'warning',
                      size: 22, color: AppColors.coral),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delete your account?',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy)),
                      Text('This can’t be undone.',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.coral)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Deleting your account permanently removes:',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy)),
            const SizedBox(height: 6),
            for (final t in const [
              'Your profile, photos and Trust Badge',
              'All interests, requests, shortlists and chats',
              'Any remaining premium membership days',
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    matchIcon(Icons.close_rounded, 'close',
                        size: 15, color: AppColors.coral),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(t,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textMuted)),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Need a break?
        _Card(
          tint: AppColors.cream,
          border: AppColors.goldBorder,
          children: [
            const Text('Need a break instead?',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy)),
            const SizedBox(height: 4),
            const Text(
              'Hide your profile for a while. Nobody can find you, and you keep everything for when you come back.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            PillButton(
              label: 'Hide my profile',
              icon: matchIcon(Icons.visibility_off_outlined, 'eye_off',
                  size: 17, color: AppColors.goldDark),
              foreground: AppColors.goldDark,
              gradient: const LinearGradient(
                  colors: [AppColors.loginA, AppColors.loginB]),
              borderColor: AppColors.goldBorder,
              onTap: widget.onHide ?? () {/* TODO */},
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Reason + confirm
        _Card(
          children: [
            const Text('Why are you leaving?',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy)),
            const SizedBox(height: 8),
            for (final r in _reasons)
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => setState(() => _reason = r),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      matchIcon(
                        r == _reason
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        'radio',
                        size: 20,
                        color:
                            r == _reason ? AppColors.tealMid : AppColors.hint,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(r,
                            style: const TextStyle(
                                fontSize: 14, color: AppColors.navy)),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            const Divider(color: AppColors.blueTintBorder),
            const SizedBox(height: 10),
            const Text('Confirm it’s you',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy)),
            const SizedBox(height: 10),
            PasswordField(label: 'Password', controller: _password),
            const SizedBox(height: 10),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => setState(() => _understood = !_understood),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    matchIcon(
                      _understood
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      'checkbox',
                      size: 22,
                      color: _understood ? AppColors.coral : AppColors.hint,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'I understand my profile and all its data will be permanently deleted.',
                        style: TextStyle(fontSize: 13, color: AppColors.navy),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: PillButton(
                    label: 'Keep account',
                    icon: const SizedBox.shrink(),
                    foreground: Colors.white,
                    gradient: kTealGradient,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Opacity(
                    opacity: _canDelete ? 1 : 0.5,
                    child: PillButton(
                      label: _busy ? 'Deleting…' : 'Delete account',
                      icon: const SizedBox.shrink(),
                      foreground: AppColors.coral,
                      background: Colors.white,
                      borderColor: AppColors.coral,
                      onTap: _canDelete ? _delete : null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children, this.tint, this.border});
  final List<Widget> children;
  final Color? tint;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tint ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border ?? AppColors.blueTintBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}