import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';

class SubscriptionPackage {
  const SubscriptionPackage({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    this.free = false,
    this.tint = AppColors.cream,
  });

  final String id;
  final String name;
  final String price; // "₹1,199.00"
  final String duration; // "3 months"
  final List<String> features;
  final bool free;
  final Color tint;
}

/// Packages from the app design — replace with your API data.
const kSamplePackages = [
  SubscriptionPackage(
    id: 'launch',
    name: 'Launching offer package',
    price: '₹0.00',
    duration: '3 months',
    free: true,
    tint: AppColors.cream,
    features: [
      'Send messages & chat with 10 profiles',
      'Send requests upto 20 profiles',
      'Send interests upto 20 profiles',
      'View contacts of 10 profiles',
      'Shortlist upto 10 profiles',
    ],
  ),
  SubscriptionPackage(
    id: 'special_basic',
    name: 'Special Basic Package',
    price: '₹1,199.00',
    duration: '3 months',
    tint: AppColors.blueTint,
    features: [
      'Send messages & chat with 30 profiles',
      'Send requests upto 100 profiles',
      'Send interests upto 100 profiles',
      'View contacts of 30 profiles',
      'Shortlist upto 60 profiles',
    ],
  ),
  SubscriptionPackage(
    id: 'regular',
    name: 'Regular Package',
    price: '₹2,199.00',
    duration: '6 months',
    tint: Color(0xFFF1EEF9),
    features: [
      'Send messages & chat with 60 profiles',
      'Send requests upto 200 profiles',
      'Send interests upto 200 profiles',
      'View contacts of 60 profiles',
      'Shortlist upto 100 profiles',
    ],
  ),
];

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({
    super.key,
    this.packages = kSamplePackages,
    this.currentPackageId = 'launch',
    this.initialSelectedId = 'special_basic',
    this.onProceedToPay,
    this.onContinueFree,
    this.showBottomNav = true,
  });

  final List<SubscriptionPackage> packages;

  /// The member's current plan (gets a "Current plan" tag).
  final String? currentPackageId;
  final String? initialSelectedId;

  /// TODO: start your payment flow (Razorpay etc.).
  final void Function(SubscriptionPackage package)? onProceedToPay;
  final VoidCallback? onContinueFree;
  final bool showBottomNav;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late String? _selected = widget.initialSelectedId;

  SubscriptionPackage? get _pkg {
    for (final p in widget.packages) {
      if (p.id == _selected) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pkg = _pkg;
    final canPay = pkg != null && !pkg.free && pkg.id != widget.currentPackageId;

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
              const SearchTopBar(title: 'Subscription'),
              Expanded(
                child: ListView(
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
                    for (final p in widget.packages) ...[
                      _PackageCard(
                        package: p,
                        selected: p.id == _selected,
                        current: p.id == widget.currentPackageId,
                        onTap: () => setState(() => _selected = p.id),
                      ),
                      const SizedBox(height: 14),
                    ],
                    _FreeCard(
                      onContinue: widget.onContinueFree ??
                          () => Navigator.of(context).maybePop(),
                    ),
                  ],
                ),
              ),

              // Pay bar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(
                      top: BorderSide(color: AppColors.blueTintBorder)),
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
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.textMuted))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  pkg.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted),
                                ),
                                Text.rich(
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
                              ],
                            ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 170,
                      child: Opacity(
                        opacity: canPay ? 1 : 0.5,
                        child: PillButton(
                          label: pkg != null && pkg.id == widget.currentPackageId
                              ? 'Current plan'
                              : 'Proceed to pay',
                          icon: matchIcon(Icons.lock_outline_rounded, 'lock',
                              size: 17, color: Colors.white),
                          foreground: Colors.white,
                          gradient: kTealGradient,
                          onTap: canPay
                              ? () => widget.onProceedToPay?.call(pkg!)
                              : null,
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                                  if (current) ...[
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.verified
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: const Text(
                                        'Current plan',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.verified,
                                        ),
                                      ),
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
                        child: Text.rich(
                          TextSpan(
                            text: p.price,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                            children: [
                              TextSpan(
                                text: '  ${p.duration}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      p.free ? AppColors.brown : AppColors.link,
                                ),
                              ),
                            ],
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