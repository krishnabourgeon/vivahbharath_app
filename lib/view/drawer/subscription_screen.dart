import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/model/get_subscriptionmodel.dart';
import 'package:vivahbharath_app/provider/home_provider.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/services/shared_preference_helper.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/dashboard_shell.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';
import 'package:vivahbharath_app/view/register/profile_under_review_screen.dart';

/// Why the subscription screen is open — decides the header and where the
/// member goes once a plan is chosen.
enum SubscriptionFlow {
  /// Opened from the drawer / profile: back button, pops when done.
  browse,

  /// Right after sign-up: no back, continues to "profile under review".
  afterSignUp,

  /// After login when no package was chosen yet: no back, continues to the
  /// dashboard.
  afterLogin,
}

class SubscriptionPackage {
  const SubscriptionPackage({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    this.apiId,
    this.strikePrice,
    this.free = false,
    this.hasPromocode = false,
    this.tint = AppColors.cream,
  });

  /// Builds a card from the `subscriptions` API row.
  factory SubscriptionPackage.fromApi(Subscription s, {required Color tint}) {
    final rate = double.tryParse(s.rate) ?? 0;
    final strike = double.tryParse(s.strikeRate ?? '');
    final reqs = {
      s.nameRequestLimit,
      s.photoRequestLimit,
      s.horoscopeRequestLimit,
      s.numberRequestLimit,
    };
    return SubscriptionPackage(
      id: '${s.id}',
      apiId: s.id,
      name: s.name,
      price: _rupees(rate),
      strikePrice: strike != null && strike > rate ? _rupees(strike) : null,
      duration: _duration(s.validity),
      free: rate == 0,
      hasPromocode: s.hasPromocode,
      tint: tint,
      features: [
        'Send messages & chat with ${s.chatLimit} profiles',
        if (reqs.length == 1)
          'Send up to ${reqs.first} requests each for Name, Photo, Horoscope and Phone Number'
        else ...[
          'Send up to ${s.nameRequestLimit} name requests',
          'Send up to ${s.photoRequestLimit} photo requests',
          'Send up to ${s.horoscopeRequestLimit} horoscope requests',
          'Send up to ${s.numberRequestLimit} phone number requests',
        ],
        'Send interests upto ${s.interestLimit} profiles',
        'View contact number of ${s.contactViewLimit} profiles',
        'Shortlist upto ${s.shortlist} profiles',
      ],
    );
  }

  final String id;
  final int? apiId;
  final String name;
  final String price; // "₹1,199.00"
  final String? strikePrice; // "₹199.00" (shown crossed out)
  final String duration; // "3 months"
  final List<String> features;
  final bool free;
  final bool hasPromocode;
  final Color tint;
}

/// "₹1,199.00" — Indian digit grouping.
String _rupees(double v) {
  final parts = v.toStringAsFixed(2).split('.');
  var whole = parts[0];
  if (whole.length > 3) {
    final last3 = whole.substring(whole.length - 3);
    var rest = whole.substring(0, whole.length - 3);
    final groups = <String>[];
    while (rest.length > 2) {
      groups.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) groups.insert(0, rest);
    whole = '${groups.join(',')},$last3';
  }
  return '₹$whole.${parts[1]}';
}

/// `validity` from the API. Values of 28+ are treated as days (90 → "3
/// months"), smaller values as months.
String _duration(int validity) {
  if (validity >= 28) {
    if (validity % 365 == 0) {
      final y = validity ~/ 365;
      return '$y year${y == 1 ? '' : 's'}';
    }
    final m = (validity / 30).round();
    if ((validity - m * 30).abs() <= 2) return '$m month${m == 1 ? '' : 's'}';
    return '$validity days';
  }
  return '$validity month${validity == 1 ? '' : 's'}';
}

const _tints = [AppColors.cream, AppColors.blueTint, Color(0xFFF1EEF9)];

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({
    super.key,
    this.flow = SubscriptionFlow.browse,
    this.packages,
    this.currentPackageId,
    this.onContinueFree,
    this.showBottomNav = true,
  });

  final SubscriptionFlow flow;

  /// Leave null to load the plans from the API.
  final List<SubscriptionPackage>? packages;

  /// The member's current plan (gets a "Current plan" tag). When null it is
  /// matched by name from the dashboard's `subscription.plan_name`.
  final String? currentPackageId;
  final VoidCallback? onContinueFree;
  final bool showBottomNav;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String? _selected;
  bool _loading = false;
  bool _choosing = false;
  List<SubscriptionPackage> _packages = const [];

  bool get _browse => widget.flow == SubscriptionFlow.browse;

  @override
  void initState() {
    super.initState();
    if (widget.packages != null) {
      _packages = widget.packages!;
      _selectDefault();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rp = context.read<RegisterProvider>();
    await rp.getSubscriptionPlans();
    if (!mounted) return;
    final list = rp.getSubscriptionModel?.subscriptions ?? const [];
    final active = list.where((s) => s.status == 1).toList()
      ..sort((a, b) => a.level.compareTo(b.level));
    final rows = active.isEmpty ? list : active;
    setState(() {
      _loading = false;
      _packages = [
        for (var i = 0; i < rows.length; i++)
          SubscriptionPackage.fromApi(rows[i], tint: _tints[i % _tints.length]),
      ];
      _selectDefault();
    });
  }

  String? get _currentId {
    if (widget.currentPackageId != null) return widget.currentPackageId;
    if (!_browse) return null;
    final plan = context
        .read<HomeProvider>()
        .dashboardModel
        ?.subscription
        ?.planName
        ?.toString()
        .trim()
        .toLowerCase();
    if (plan == null || plan.isEmpty) return null;
    for (final p in _packages) {
      if (p.name.trim().toLowerCase() == plan) return p.id;
    }
    return null;
  }

  void _selectDefault() {
    if (_packages.isEmpty) return;
    final current = _currentId;
    // Pre-select the first plan that isn't the current one.
    _selected = _packages
        .firstWhere((p) => p.id != current, orElse: () => _packages.first)
        .id;
  }

  SubscriptionPackage? get _pkg {
    for (final p in _packages) {
      if (p.id == _selected) return p;
    }
    return null;
  }

  // ── Choosing a plan ──────────────────────────────────────────────

  Future<void> _onChoose(SubscriptionPackage pkg) async {
    if (_choosing || pkg.apiId == null) return;
    if (pkg.hasPromocode) {
      // The popup calls the API itself so a wrong code keeps it open
      // with the error under the field.
      final done = await PromoCodeDialog.show(
        context,
        onSubmit: (code) => _choose(pkg, code),
      );
      if (done == true) await _afterChosen();
      return;
    }
    setState(() => _choosing = true);
    final error = await _choose(pkg, '');
    if (!mounted) return;
    setState(() => _choosing = false);
    if (error != null) return showMsg(error);
    await _afterChosen();
  }

  /// Calls `subscription/choose`. Returns an error message, or null on
  /// success.
  Future<String?> _choose(SubscriptionPackage pkg, String promocode) async {
    final rp = context.read<RegisterProvider>();
    final ok = await rp.chooseSubscription(pkg.apiId!, promocode);
    if (!ok) {
      return rp.chooseSubscriptionError ??
          'Could not choose this plan. Please try again';
    }
    await SharedPreferenceHelper.saveSubscriptionChosen(true);
    final msg = rp.chooseSubscriptionModel?.message;
    if (msg != null && msg.isNotEmpty) showMsg(msg);
    return null;
  }

  Future<void> _afterChosen() async {
    if (!mounted) return;
    switch (widget.flow) {
      case SubscriptionFlow.browse:
        // Refresh "Current plan" on the home screen, then go back.
        context.read<HomeProvider>().getDashboard();
        Navigator.of(context).maybePop(true);
      case SubscriptionFlow.afterSignUp:
        _replaceWith(const ProfileUnderReviewScreen());
      case SubscriptionFlow.afterLogin:
        _replaceWith(const DashboardShell());
    }
  }

  void _onContinueFree() {
    if (widget.onContinueFree != null) return widget.onContinueFree!();
    switch (widget.flow) {
      case SubscriptionFlow.browse:
        Navigator.of(context).maybePop();
      case SubscriptionFlow.afterSignUp:
        _replaceWith(const ProfileUnderReviewScreen());
      case SubscriptionFlow.afterLogin:
        _replaceWith(const DashboardShell());
    }
  }

  void _replaceWith(Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (r) => false,
    );
  }

  // ── UI ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final pkg = _pkg;
    final current = _currentId;
    final isCurrent = pkg != null && pkg.id == current;
    final canChoose = pkg != null && !isCurrent && !_choosing;

    return PopScope(
      // Sign-up / login flows have nowhere to go back to.
      canPop: _browse,
      child: Scaffold(
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
                if (_browse)
                  const SearchTopBar(title: 'Subscription')
                else
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 14),
                    child: Text(
                      'Choose a plan to get started',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                Expanded(child: _body(current)),
                _payBar(pkg, isCurrent, canChoose),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(String? current) {
    if (_loading && _packages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.tealB),
      );
    }
    return RefreshIndicator(
      color: AppColors.tealB,
      onRefresh: widget.packages == null ? _load : () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          _Hero(),
          const SizedBox(height: 16),
          const Text(
            'Packages',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 12),
          if (_packages.isEmpty)
            _EmptyPlans(onRetry: _load)
          else
            for (final p in _packages) ...[
              _PackageCard(
                package: p,
                selected: p.id == _selected,
                current: p.id == current,
                onTap: () => setState(() => _selected = p.id),
              ),
              const SizedBox(height: 14),
            ],
          _FreeCard(onContinue: _onContinueFree),
        ],
      ),
    );
  }

  Widget _payBar(SubscriptionPackage? pkg, bool isCurrent, bool canChoose) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 10, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.blueTintBorder)),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealDark.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: pkg == null
                ? const Text('Choose a package',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pkg.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMuted),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            text: pkg.price,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                            children: [
                              TextSpan(
                                text: '  /  ${pkg.duration}',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 170,
            child: Opacity(
              opacity: canChoose ? 1 : 0.5,
              child: PillButton(
                label: isCurrent
                    ? 'Current plan'
                    : _choosing
                        ? 'Please wait…'
                        : pkg != null && pkg.free
                            ? 'Activate plan'
                            : 'Choose plan',
                icon: _choosing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : matchIcon(Icons.lock_outline_rounded, 'lock',
                        size: 17, color: Colors.white),
                foreground: Colors.white,
                gradient: kTealGradient,
                onTap: canChoose ? () => _onChoose(pkg!) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Promo code popup ───────────────────────────────────────────────

/// "Please enter your promo code" popup.
///
/// [onSubmit] receives the code ('' for Skip) and returns an error message,
/// or null on success. The popup closes with `true` on success and `null`
/// when dismissed with the close button.
class PromoCodeDialog extends StatefulWidget {
  const PromoCodeDialog({super.key, required this.onSubmit});

  final Future<String?> Function(String code) onSubmit;

  static Future<bool?> show(
    BuildContext context, {
    required Future<String?> Function(String code) onSubmit,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PromoCodeDialog(onSubmit: onSubmit),
    );
  }

  @override
  State<PromoCodeDialog> createState() => _PromoCodeDialogState();
}

class _PromoCodeDialogState extends State<PromoCodeDialog> {
  static const _accent = Color(0xFFE14F3B);

  final _ctrl = TextEditingController();
  String? _error;
  bool _showInfo = false;

  /// Which button is busy: 'skip', 'submit' or null.
  String? _busy;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _run(String which, String code) async {
    if (_busy != null) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = which;
      _error = null;
    });
    final error = await widget.onSubmit(code);
    if (!mounted) return;
    if (error == null) return Navigator.of(context).pop(true);
    setState(() {
      _busy = null;
      _error = error;
    });
  }

  void _submit() {
    final code = _ctrl.text.trim();
    if (code.isEmpty) {
      setState(() => _error = 'Please enter a promo code, or tap Skip');
      return;
    }
    _run('submit', code);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 6, 14),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Please enter your promo code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed:
                        _busy == null ? () => Navigator.of(context).pop() : null,
                    icon: const Icon(Icons.close_rounded,
                        size: 26, color: Color(0xFF6B6B6B)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Promo Code',
                        style:
                            TextStyle(fontSize: 14.5, color: Color(0xFF555555)),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => setState(() => _showInfo = !_showInfo),
                        child: const Text(
                          'What is a promocode?',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: _accent,
                            decoration: TextDecoration.underline,
                            decorationColor: _accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showInfo) ...[
                    const SizedBox(height: 6),
                    const Text(
                      'A promo code is a special code shared by Vivah Bharath '
                      'or our partners. Enter it here to get a discount or '
                      'unlock this package. No code? Just tap Skip.',
                      style: TextStyle(
                          fontSize: 12.5, height: 1.4, color: Color(0xFF6B6B6B)),
                    ),
                  ],
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ctrl,
                    enabled: _busy == null,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
                      filled: true,
                      fillColor: const Color(0xFFF4F4F4),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: _border(const Color(0xFFDADADA)),
                      enabledBorder: _border(_error != null
                          ? _accent
                          : const Color(0xFFDADADA)),
                      focusedBorder: _border(_accent),
                      disabledBorder: _border(const Color(0xFFDADADA)),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _error!,
                      style: const TextStyle(fontSize: 12.5, color: _accent),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _PromoButton(
                          label: 'Skip',
                          busy: _busy == 'skip',
                          onTap: _busy == null ? () => _run('skip', '') : null,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _PromoButton(
                          label: 'Submit',
                          busy: _busy == 'submit',
                          onTap: _busy == null ? _submit : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: c),
      );
}

class _PromoButton extends StatelessWidget {
  const _PromoButton({
    required this.label,
    required this.busy,
    required this.onTap,
  });

  final String label;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: _PromoCodeDialogState._accent,
          disabledBackgroundColor:
              _PromoCodeDialogState._accent.withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        child: busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}

// ── Pieces ─────────────────────────────────────────────────────────

class _EmptyPlans extends StatelessWidget {
  const _EmptyPlans({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Column(
        children: [
          const Text(
            'Could not load the packages.',
            style: TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Try again',
                style: TextStyle(
                    color: AppColors.tealMid, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealB, AppColors.tealC],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose your subscription',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.sparkleGold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              matchIcon(Icons.lock_outline_rounded, 'lock',
                  size: 15, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                'and make payment securely',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.selected,
    required this.current,
    required this.onTap,
  });

  final SubscriptionPackage package;
  final bool selected;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = package;
    final r = BorderRadius.circular(22);

    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, p.tint],
              ),
              borderRadius: r,
              border: Border.all(
                color: selected ? AppColors.tealMid : AppColors.blueTintBorder,
                width: selected ? 2 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.tealMid.withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: r,
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: p.free ? 70 : 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  if (current || p.hasPromocode) ...[
                                    const SizedBox(height: 4),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: [
                                        if (current)
                                          const _Tag(
                                            label: 'Current plan',
                                            color: AppColors.verified,
                                          ),
                                        if (p.hasPromocode)
                                          const _Tag(
                                            label: 'Promo code accepted',
                                            color: AppColors.coral,
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          _Radio(selected: selected),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.blueTintBorder),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                if (p.strikePrice != null)
                                  TextSpan(
                                    text: '${p.strikePrice}  ',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textMuted,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                TextSpan(
                                  text: p.price,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                                TextSpan(
                                  text: '  ${p.duration}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: p.free
                                        ? AppColors.brown
                                        : AppColors.link,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final f in p.features)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: matchIcon(Icons.add_rounded, 'plus',
                                    size: 15,
                                    color: p.free
                                        ? AppColors.marigoldO
                                        : AppColors.tealMid),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  f,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    height: 1.3,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (p.free)
            const Positioned(top: -6, right: 46, child: _FreeSeal()),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.tealMid : Colors.white,
        border: Border.all(
          color: selected ? AppColors.tealMid : AppColors.fieldBorder,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: matchIcon(Icons.check_rounded, 'check',
                  size: 16, color: Colors.white),
            )
          : null,
    );
  }
}

class _FreeSeal extends StatelessWidget {
  const _FreeSeal();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [AppColors.marigoldY, AppColors.marigoldO],
        ),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.marigoldO.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '100%',
            style: TextStyle(
              fontSize: 15,
              height: 1,
              fontWeight: FontWeight.w800,
              color: AppColors.goldDark,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'FREE',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1,
              fontWeight: FontWeight.w800,
              color: AppColors.goldDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _FreeCard extends StatelessWidget {
  const _FreeCard({required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: matchIcon(Icons.card_giftcard_rounded, 'gift',
                    size: 20, color: AppColors.goldDark),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Not ready to subscribe yet?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Continue exploring matches with a free membership — upgrade anytime.',
                      style: TextStyle(
                          fontSize: 13, height: 1.4, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PillButton(
            label: 'Continue as Free Member',
            icon: const SizedBox.shrink(),
            foreground: AppColors.goldDark,
            gradient: const LinearGradient(
                colors: [AppColors.loginA, AppColors.loginB]),
            borderColor: AppColors.goldBorder,
            onTap: onContinue,
          ),
        ],
      ),
    );
  }
}
