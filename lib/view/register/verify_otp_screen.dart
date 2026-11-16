// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vivahbharath_app/view/custom/app_colors.dart';
// import 'package:vivahbharath_app/view/custom/responsive.dart';
// import 'package:vivahbharath_app/view/register/basic_info_screen.dart';

// class VerifyCodeScreen extends StatefulWidget {
//   final String maskedPhone;
//   const VerifyCodeScreen({super.key, this.maskedPhone = '+91 98••••••12'});

//   @override
//   State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
// }

// class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
//   static const _length = 4;
//   static const _resendSeconds = 30;

//   final _ctrl = TextEditingController();
//   final _focus = FocusNode();
//   Timer? _timer;
//   int _remaining = _resendSeconds;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//     _ctrl.addListener(() => setState(() {}));
//     _focus.addListener(() => setState(() {}));
//   }

//   void _startTimer() {
//     _timer?.cancel();
//     setState(() => _remaining = _resendSeconds);
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (_remaining <= 1) {
//         t.cancel();
//         setState(() => _remaining = 0);
//       } else {
//         setState(() => _remaining--);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _ctrl.dispose();
//     _focus.dispose();
//     super.dispose();
//   }

//   String get _timeText {
//     final m = (_remaining ~/ 60).toString().padLeft(2, '0');
//     final s = (_remaining % 60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }

//   void _onVerify() {
//     FocusScope.of(context).unfocus();
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => BasicInfoScreen()),
//     );
//   }

//   void _onResend() {
//     _ctrl.clear();
//     _startTimer();
//     // TODO: call resend API
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Hero, content and buttons scroll together, so nothing overflows on
//     // short screens, in landscape or with the keyboard open.
//     final side = contentSidePadding(context);
//     return Scaffold(
//       backgroundColor: AppColors.cream,
//       body: CustomScrollView(
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         slivers: [
//           const SliverToBoxAdapter(child: _Hero()),
//           SliverFillRemaining(
//             hasScrollBody: false,
//             child: SafeArea(
//               top: false,
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(24 + side, 28, 24 + side, 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Enter verification code',
//                       style: GoogleFonts.fraunces(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.headline,
//                         height: 1.1,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text.rich(
//                       TextSpan(
//                         children: [
//                           const TextSpan(text: 'We sent a 6-digit code to '),
//                           TextSpan(
//                             text: widget.maskedPhone,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.headline,
//                             ),
//                           ),
//                           const TextSpan(text: '. '),
//                           WidgetSpan(
//                             // middle (not baseline): the scroll layout measures
//                             // intrinsic height, which baseline spans don't support
//                             alignment: PlaceholderAlignment.middle,
//                             child: GestureDetector(
//                               onTap: () => Navigator.maybePop(context),
//                               child: Text(
//                                 'Change',
//                                 style: GoogleFonts.dmSans(
//                                   fontSize: 16,
//                                   height: 1.5,
//                                   fontWeight: FontWeight.w700,
//                                   color: AppColors.link,
//                                   decoration: TextDecoration.underline,
//                                   decorationColor: AppColors.link,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       style: GoogleFonts.dmSans(
//                         fontSize: 16,
//                         height: 1.5,
//                         color: AppColors.body,
//                       ),
//                     ),
//                     const SizedBox(height: 28),
//                     // boxes don't stretch absurdly wide on tablets
//                     Center(
//                       child: ConstrainedBox(
//                         constraints: const BoxConstraints(maxWidth: 360),
//                         child: _otpRow(),
//                       ),
//                     ),
//                     const SizedBox(height: 22),
//                     Center(child: _resendRow()),
//                     const SizedBox(height: 22),
//                     const _InfoCard(),
//                     const Spacer(),
//                     const SizedBox(height: 24),
//                     _PrimaryButton(label: 'Verify', onTap: _onVerify),
//                     const SizedBox(height: 14),
//                     // full width, so WrapAlignment.center can centre it
//                     SizedBox(
//                       width: double.infinity,
//                       child: Wrap(
//                         alignment: WrapAlignment.center,
//                         crossAxisAlignment: WrapCrossAlignment.center,
//                         children: [
//                           Text(
//                             "Didn't get it? ",
//                             style: GoogleFonts.dmSans(
//                               fontSize: 15,
//                               color: AppColors.body,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: _onResend,
//                             child: Text(
//                               'Send by SMS again',
//                               style: GoogleFonts.dmSans(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w700,
//                                 color: AppColors.link,
//                                 decoration: TextDecoration.underline,
//                                 decorationColor: AppColors.link,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /* ── OTP boxes (one hidden TextField drives all six) ── */

//   Widget _otpRow() {
//     final text = _ctrl.text;
//     final activeIndex = text.length.clamp(0, _length - 1);

//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () => _focus.requestFocus(),
//       child: Stack(
//         children: [
//           Row(
//             children: List.generate(_length * 2 - 1, (i) {
//               if (i.isOdd) return const SizedBox(width: 12);
//               final index = i ~/ 2;
//               final filled = index < text.length;
//               final focused = _focus.hasFocus && index == activeIndex;
//               return Expanded(
//                 child: _OtpBox(
//                   char: filled ? text[index] : '',
//                   focused: focused,
//                 ),
//               );
//             }),
//           ),
//           // hidden input
//           Positioned(
//             left: 0,
//             top: 0,
//             child: SizedBox(
//               width: 1,
//               height: 1,
//               child: Opacity(
//                 opacity: 0,
//                 child: TextField(
//                   controller: _ctrl,
//                   focusNode: _focus,
//                   autofocus: true,
//                   keyboardType: TextInputType.number,
//                   maxLength: _length,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   enableInteractiveSelection: false,
//                   decoration: const InputDecoration(
//                     counterText: '',
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _resendRow() {
//     final style = GoogleFonts.dmSans(fontSize: 17, color: AppColors.body);
//     if (_remaining == 0) {
//       return GestureDetector(
//         onTap: _onResend,
//         child: Text(
//           'Resend code',
//           style: style.copyWith(
//             fontWeight: FontWeight.w700,
//             color: AppColors.forever,
//           ),
//         ),
//       );
//     }
//     return Wrap(
//       alignment: WrapAlignment.center,
//       crossAxisAlignment: WrapCrossAlignment.center,
//       children: [
//         const Icon(Icons.schedule_rounded, size: 24, color: AppColors.forever),
//         const SizedBox(width: 10),
//         Text('Resend code in ', style: style),
//         const SizedBox(width: 4),
//         Text(
//           _timeText,
//           style: style.copyWith(
//             fontWeight: FontWeight.w700,
//             color: AppColors.forever,
//             fontFeatures: const [FontFeature.tabularFigures()],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _OtpBox extends StatelessWidget {
//   final String char;
//   final bool focused;
//   const _OtpBox({required this.char, required this.focused});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 150),
//       constraints: const BoxConstraints(minHeight: 56),
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: focused ? AppColors.tealB : AppColors.fieldBorder,
//           width: focused ? 2.5 : 1.5,
//         ),
//         boxShadow: focused
//             ? [
//                 BoxShadow(
//                   color: AppColors.tealB.withOpacity(0.16),
//                   spreadRadius: 5,
//                   blurRadius: 0,
//                 ),
//               ]
//             : null,
//       ),
//       child: Text(
//         char,
//         style: GoogleFonts.dmSans(
//           fontSize: 28,
//           fontWeight: FontWeight.w700,
//           color: AppColors.headline,
//         ),
//       ),
//     );
//   }
// }

// class _InfoCard extends StatelessWidget {
//   const _InfoCard();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(22),
//         border: Border.all(color: AppColors.fieldBorder, width: 1.5),
//         gradient: const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.white, Color(0xFFE6EEFA)],
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(top: 2),
//             child: Icon(Icons.shield_outlined, size: 26, color: AppColors.link),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               'Never share this code with anyone, including people who '
//               'say they are from Vivah Bharath.',
//               style: GoogleFonts.dmSans(
//                 fontSize: 16,
//                 height: 1.45,
//                 color: AppColors.body,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ───────────────────────── HERO ───────────────────────── */

// class _Hero extends StatelessWidget {
//   const _Hero();

//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     final top = mq.padding.top;
//     // 215 on a typical phone; shorter in landscape, a bit taller on tablets.
//     final h = (mq.size.height * 0.255).clamp(150.0, 260.0);
//     final k = h / 215;
//     return ClipPath(
//       clipper: _WaveClipper(),
//       child: Container(
//         height: h + top,
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [AppColors.tealA, AppColors.tealB, AppColors.tealC],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // soft glow top-right
//             Positioned(
//               right: -40,
//               top: top + 10 * k,
//               child: Container(
//                 width: 220 * k,
//                 height: 220 * k,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [AppColors.glow, AppColors.glowEnd],
//                   ),
//                 ),
//               ),
//             ),
//             // hearts + thread (single image)
//             Positioned(
//               top: top + 76 * k,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Image.asset(
//                   'assets/images/hearts_illustration_transparent.png',
//                   width: 156 * k,
//                 ),
//               ),
//             ),
//             // logo
//             Positioned(
//               top: top + 18 * k,
//               left: 0,
//               right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/logo-mark-gold@3x.png',
//                     height: 25 * k,
//                   ),
//                   const SizedBox(width: 5),
//                   Flexible(
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Text(
//                         'vivahbharath',
//                         style: GoogleFonts.fraunces(
//                           fontSize: 26,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.sparkleGold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // step dots: step 2 of 3
//             // Positioned(
//             //   top: top + 62,
//             //   left: 0,
//             //   right: 0,
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: [
//             //       _dot(8, AppColors.sparkleGold),
//             //       const SizedBox(width: 6),
//             //       _dot(26, AppColors.sparkleGold),
//             //       const SizedBox(width: 6),
//             //       _dot(8, Colors.white38),
//             //     ],
//             //   ),
//             // ),
//             // // back button
//             // Positioned(
//             //   top: top + 8,
//             //   left: 18,
//             //   child: GestureDetector(
//             //     onTap: () => Navigator.maybePop(context),
//             //     child: Container(
//             //       width: 46,
//             //       height: 46,
//             //       decoration: BoxDecoration(
//             //         shape: BoxShape.circle,
//             //         color: Colors.white.withOpacity(0.16),
//             //         border: Border.all(color: Colors.white38),
//             //       ),
//             //       child: const Icon(Icons.chevron_left,
//             //           color: Colors.white, size: 28),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _dot(double w, Color c) => Container(
//     width: w,
//     height: 8,
//     decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)),
//   );
// }

// class _WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final p = Path()..lineTo(0, size.height - 22);
//     p.cubicTo(
//       size.width * 0.18,
//       size.height - 40,
//       size.width * 0.38,
//       size.height - 6,
//       size.width * 0.58,
//       size.height - 14,
//     );
//     p.cubicTo(
//       size.width * 0.78,
//       size.height - 22,
//       size.width * 0.9,
//       size.height - 44,
//       size.width,
//       size.height - 34,
//     );
//     p.lineTo(size.width, 0);
//     p.close();
//     return p;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> old) => false;
// }

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//   const _PrimaryButton({required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       height: 62,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(31),
//         gradient: const LinearGradient(
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//           colors: [AppColors.btnA, AppColors.tealC],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.tealC.withOpacity(0.28),
//             blurRadius: 18,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.dmSans(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(width: 12),
//           const Icon(
//             Icons.arrow_forward_rounded,
//             color: AppColors.sparkleGold,
//             size: 24,
//           ),
//         ],
//       ),
//     ),
//   );
// }



import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivahbharath_app/provider/register_provider.dart';
import 'package:vivahbharath_app/services/register_helpers.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/responsive.dart';
import 'package:vivahbharath_app/view/register/basic_info_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  /// 10-digit number the OTP was sent to (used for verify / resend).
  final String mobile;
  final String maskedPhone;
  const VerifyCodeScreen({
    super.key,
    required this.mobile,
    this.maskedPhone = '+91 98••••••12',
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  static const _length = 4;
  static const _resendSeconds = 30;

  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _remaining = _resendSeconds;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _ctrl.addListener(() => setState(() {}));
    _focus.addListener(() => setState(() {}));
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remaining = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 1) {
        t.cancel();
        setState(() => _remaining = 0);
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  String get _timeText {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _onVerify() async {
    FocusScope.of(context).unfocus();
    if (_busy) return;

    final code = _ctrl.text.trim();
    if (code.length != _length) {
      return showMsg('Please enter the $_length-digit code');
    }

    final rp = context.read<RegisterProvider>();
    setState(() => _busy = true);
    // the token is stored by the service layer on success
    final ok = await rp.verifyOtp(widget.mobile, int.parse(code));
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) {
      return showMsg(rp.verifyOtpError ?? 'Invalid OTP. Please try again');
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BasicInfoScreen()),
    );
  }

  Future<void> _onResend() async {
    if (_busy) return;
    final rp = context.read<RegisterProvider>();
    setState(() => _busy = true);
    // The account already exists after signup, so sign-in re-sends the OTP.
    final ok = await rp.signIn(widget.mobile);
    if (!mounted) return;
    setState(() => _busy = false);

    if (!ok) {
      return showMsg(rp.signInError ?? 'Could not resend the code');
    }
    _ctrl.clear();
    _startTimer();
    showMsg('Verification code sent');
  }

  @override
  Widget build(BuildContext context) {
    // Hero, content and buttons scroll together, so nothing overflows on
    // short screens, in landscape or with the keyboard open.
    final side = contentSidePadding(context);
    return BusyOverlay(
      busy: _busy,
      child: Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const SliverToBoxAdapter(child: _Hero()),
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24 + side, 28, 24 + side, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter verification code',
                      style: GoogleFonts.fraunces(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.headline,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'We sent a 6-digit code to '),
                          TextSpan(
                            text: widget.maskedPhone,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.headline,
                            ),
                          ),
                          const TextSpan(text: '. '),
                          WidgetSpan(
                            // middle (not baseline): the scroll layout measures
                            // intrinsic height, which baseline spans don't support
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () => Navigator.maybePop(context),
                              child: Text(
                                'Change',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  height: 1.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.link,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.link,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.body,
                      ),
                    ),
                    const SizedBox(height: 28),
                    // boxes don't stretch absurdly wide on tablets
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: _otpRow(),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Center(child: _resendRow()),
                    const SizedBox(height: 22),
                    const _InfoCard(),
                    const Spacer(),
                    const SizedBox(height: 24),
                    _PrimaryButton(label: 'Verify', onTap: _onVerify),
                    const SizedBox(height: 14),
                    // full width, so WrapAlignment.center can centre it
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "Didn't get it? ",
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              color: AppColors.body,
                            ),
                          ),
                          GestureDetector(
                            onTap: _onResend,
                            child: Text(
                              'Send by SMS again',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.link,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.link,
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
        ],
      ),
    ));
  }

  /* ── OTP boxes (one hidden TextField drives all six) ── */

  Widget _otpRow() {
    final text = _ctrl.text;
    final activeIndex = text.length.clamp(0, _length - 1);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _focus.requestFocus(),
      child: Stack(
        children: [
          Row(
            children: List.generate(_length * 2 - 1, (i) {
              if (i.isOdd) return const SizedBox(width: 12);
              final index = i ~/ 2;
              final filled = index < text.length;
              final focused = _focus.hasFocus && index == activeIndex;
              return Expanded(
                child: _OtpBox(
                  char: filled ? text[index] : '',
                  focused: focused,
                ),
              );
            }),
          ),
          // hidden input
          Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              width: 1,
              height: 1,
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focus,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: _length,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  enableInteractiveSelection: false,
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resendRow() {
    final style = GoogleFonts.dmSans(fontSize: 17, color: AppColors.body);
    if (_remaining == 0) {
      return GestureDetector(
        onTap: _onResend,
        child: Text(
          'Resend code',
          style: style.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.forever,
          ),
        ),
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Icon(Icons.schedule_rounded, size: 24, color: AppColors.forever),
        const SizedBox(width: 10),
        Text('Resend code in ', style: style),
        const SizedBox(width: 4),
        Text(
          _timeText,
          style: style.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.forever,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _OtpBox extends StatelessWidget {
  final String char;
  final bool focused;
  const _OtpBox({required this.char, required this.focused});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: focused ? AppColors.tealB : AppColors.fieldBorder,
          width: focused ? 2.5 : 1.5,
        ),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: AppColors.tealB.withOpacity(0.16),
                  spreadRadius: 5,
                  blurRadius: 0,
                ),
              ]
            : null,
      ),
      child: Text(
        char,
        style: GoogleFonts.dmSans(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.headline,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.fieldBorder, width: 1.5),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFE6EEFA)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.shield_outlined, size: 26, color: AppColors.link),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Never share this code with anyone, including people who '
              'say they are from Vivah Bharath.',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                height: 1.45,
                color: AppColors.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ───────────────────────── HERO ───────────────────────── */

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final top = mq.padding.top;
    // 215 on a typical phone; shorter in landscape, a bit taller on tablets.
    final h = (mq.size.height * 0.255).clamp(150.0, 260.0);
    final k = h / 215;
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        height: h + top,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.tealA, AppColors.tealB, AppColors.tealC],
          ),
        ),
        child: Stack(
          children: [
            // soft glow top-right
            Positioned(
              right: -40,
              top: top + 10 * k,
              child: Container(
                width: 220 * k,
                height: 220 * k,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColors.glow, AppColors.glowEnd],
                  ),
                ),
              ),
            ),
            // hearts + thread (single image)
            Positioned(
              top: top + 76 * k,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/hearts_illustration_transparent.png',
                  width: 156 * k,
                ),
              ),
            ),
            // logo
            Positioned(
              top: top + 18 * k,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo-mark-gold@3x.png',
                    height: 25 * k,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'vivahbharath',
                        style: GoogleFonts.fraunces(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: AppColors.sparkleGold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // step dots: step 2 of 3
            // Positioned(
            //   top: top + 62,
            //   left: 0,
            //   right: 0,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       _dot(8, AppColors.sparkleGold),
            //       const SizedBox(width: 6),
            //       _dot(26, AppColors.sparkleGold),
            //       const SizedBox(width: 6),
            //       _dot(8, Colors.white38),
            //     ],
            //   ),
            // ),
            // // back button
            // Positioned(
            //   top: top + 8,
            //   left: 18,
            //   child: GestureDetector(
            //     onTap: () => Navigator.maybePop(context),
            //     child: Container(
            //       width: 46,
            //       height: 46,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Colors.white.withOpacity(0.16),
            //         border: Border.all(color: Colors.white38),
            //       ),
            //       child: const Icon(Icons.chevron_left,
            //           color: Colors.white, size: 28),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _dot(double w, Color c) => Container(
    width: w,
    height: 8,
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)),
  );
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path()..lineTo(0, size.height - 22);
    p.cubicTo(
      size.width * 0.18,
      size.height - 40,
      size.width * 0.38,
      size.height - 6,
      size.width * 0.58,
      size.height - 14,
    );
    p.cubicTo(
      size.width * 0.78,
      size.height - 22,
      size.width * 0.9,
      size.height - 44,
      size.width,
      size.height - 34,
    );
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 62,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.btnA, AppColors.tealC],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealC.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.sparkleGold,
            size: 24,
          ),
        ],
      ),
    ),
  );
}