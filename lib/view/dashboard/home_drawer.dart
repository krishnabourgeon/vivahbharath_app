// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vivahbharath_app/view/custom/app_colors.dart';
// import 'package:vivahbharath_app/view/custom/app_icon.dart';
// import 'package:vivahbharath_app/view/dashboard/edit_profile_screen.dart';
// import 'package:vivahbharath_app/view/drawer/manage_photo_screen.dart';
// import 'package:vivahbharath_app/view/drawer/partner_preference_screen.dart';
// import 'package:vivahbharath_app/view/drawer/safe_matrminoy_screen.dart';

// class HomeDrawer extends StatelessWidget {
//   const HomeDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       width: MediaQuery.of(context).size.width * 0.78,
//       backgroundColor: const Color(0xFFF7F9FD),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(topRight: Radius.circular(36.r), bottomRight: Radius.circular(36.r)),
//       ),
//       child: Column(
//         children: [
//           const _DrawerHeader(),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
//               children:  [
//                 _GroupLabel('MY PROFILE'),
//                 _DrawerItem(icon: 'edit_profile', label: 'Edit Profile', bg: Color(0xFFDCE7F7), fg: AppColors.navy, onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(),));
//                 },),
//                 _DrawerItem(icon: 'manage_photos', label: 'Manage Photos', bg: Color(0xFFFBE6D0), fg: AppColors.brown,onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePhotosScreen()));
//                 },),
//                 _DrawerItem(icon: 'heart', label: 'Partner Preferences', bg: Color(0xFFFADDD6), fg: AppColors.coral,onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerPreferencesScreen()));
//                 },),
//                 _DrawerItem(icon: 'trust_badge', label: 'Trust Badge', bg: Color(0xFFDDF1E4), fg: AppColors.verified,onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => SafeMatrimonyScreen(),));
//                 },),
//                 _DrawerItem(icon: 'safe_matrimony', label: 'Safe Matrimony', bg: Color(0xFFDCE7F7), fg: AppColors.navy),
//                 _GroupLabel('MATCHES'),
//                 _DrawerItem(icon: 'matches_search', label: 'Search', bg: Color(0xFFDCE7F7), fg: AppColors.navy),
//                 _DrawerItem(icon: 'search_results', label: 'Search results', bg: Color(0xFFE6E1F6), fg: AppColors.purple),
//                 _GroupLabel('ACTIVITY'),
//                 _DrawerItem(icon: 'inbox', label: 'Inbox & Requests', bg: Color(0xFFFBE6D0), fg: AppColors.brown),
//                 _DrawerItem(icon: 'chats', label: 'Chats', bg: Color(0xFFDCE7F7), fg: AppColors.navy),
//                 _GroupLabel('ACCOUNT'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DrawerHeader extends StatelessWidget {
//   const _DrawerHeader();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.fromLTRB(20.w, MediaQuery.of(context).padding.top + 16.h, 20.w, 20.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(topRight: Radius.circular(36.r)),
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [AppColors.tealLight, AppColors.tealMid, AppColors.tealDark],
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 76.w,
//                 height: 76.w,
//                 padding: EdgeInsets.all(3.w),
//                 decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.goldBorder),
//                 child: ClipOval(child: Image.asset('assets/images/avatar_male.png', fit: BoxFit.cover)),
//               ),
//               const Spacer(),
//               InkWell(
//                 onTap: () => Navigator.of(context).pop(),
//                 customBorder: const CircleBorder(),
//                 child: Container(
//                   width: 44.w,
//                   height: 44.w,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.12),
//                     border: Border.all(color: Colors.white.withOpacity(0.35)),
//                   ),
//                   child: Center(child: AppIcon('close', size: 20, color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           Text('Priyesh', style: GoogleFonts.dmSans(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.white)),
//           SizedBox(height: 2.h),
//           Text('VBM26836413F', style: GoogleFonts.dmSans(fontSize: 15.sp, color: Colors.white.withOpacity(0.8))),
//           SizedBox(height: 16.h),
//           Row(
//             children: [
//               Expanded(child: Text('Profile completed', style: GoogleFonts.dmSans(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white))),
//               Text('63%', style: GoogleFonts.dmSans(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.goldBorder)),
//             ],
//           ),
//           SizedBox(height: 8.h),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(4.r),
//             child: LinearProgressIndicator(
//               value: 0.63,
//               minHeight: 7.h,
//               backgroundColor: Colors.white.withOpacity(0.2),
//               valueColor: const AlwaysStoppedAnimation(AppColors.gold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _GroupLabel extends StatelessWidget {
//   const _GroupLabel(this.text);
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(4.w, 20.h, 0, 8.h),
//       child: Text(text, style: GoogleFonts.dmSans(fontSize: 13.sp, fontWeight: FontWeight.w700, letterSpacing: 1.6, color: AppColors.textMuted)),
//     );
//   }
// }

// class _DrawerItem extends StatelessWidget {
//   const _DrawerItem({required this.icon, required this.label, required this.bg, required this.fg, this.onTap});
//   final String icon;
//   final String label;
//   final Color bg;
//   final Color fg;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16.r),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 8.h),
//         child: Row(
//           children: [
//             Container(
//               width: 44.w,
//               height: 44.w,
//               decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14.r)),
//               child: Center(child: AppIcon(icon, size: 22, color: fg)),
//             ),
//             SizedBox(width: 16.w),
//             Expanded(child: Text(label, style: GoogleFonts.dmSans(fontSize: 17.sp, fontWeight: FontWeight.w700, color: AppColors.navyDark))),
//             AppIcon('chevron_right', size: 20, color: AppColors.textMuted),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/app_icon.dart';
import 'package:vivahbharath_app/view/dashboard/edit_profile_screen.dart';
import 'package:vivahbharath_app/view/drawer/chat_screen.dart';
import 'package:vivahbharath_app/view/drawer/manage_interset_screen.dart';
import 'package:vivahbharath_app/view/drawer/manage_photo_screen.dart';
import 'package:vivahbharath_app/view/drawer/manage_request.dart';
import 'package:vivahbharath_app/view/drawer/partner_preference_screen.dart';
import 'package:vivahbharath_app/view/drawer/privacy_settings.dart';
import 'package:vivahbharath_app/view/drawer/safe_matrminoy_screen.dart';
import 'package:vivahbharath_app/view/dashboard/inbox_screen.dart';
import 'package:vivahbharath_app/view/drawer/subscription_screen.dart';
import 'package:vivahbharath_app/view/drawer/trust_badge.dart';
import 'package:vivahbharath_app/view/drawer/verify_profile_screen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  /// Closes the drawer, then opens [page].
  void _go(BuildContext context, Widget page) {
    final nav = Navigator.of(context);
    nav.pop();
    nav.push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: const Color(0xFFF7F9FD),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36.r),
          bottomRight: Radius.circular(36.r),
        ),
      ),
      child: Column(
        children: [
          const _DrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              children: [
                // ── MY PROFILE ─────────────────────────────────────────────
                const _GroupLabel('MY PROFILE'),
                _DrawerItem(
                  icon: 'edit_profile',
                  label: 'Edit Profile',
                  bg: const Color(0xFFDCE7F7),
                  fg: AppColors.navy,
                  onTap: () => _go(context, EditProfileScreen()),
                ),
                _DrawerItem(
                  icon: 'manage_photos',
                  label: 'Manage photos',
                  bg: const Color(0xFFFBE6D0),
                  fg: AppColors.brown,
                  onTap: () => _go(context, ManagePhotosScreen()),
                ),
                _DrawerItem(
                  icon: 'partner_preference',
                  label: 'Edit partner preference',
                  bg: const Color(0xFFFADDD6),
                  fg: AppColors.coral,
                  onTap: () => _go(context, PartnerPreferencesScreen()),
                ),
                _DrawerItem(
                  icon: 'trust_badge',
                  label: 'Add trust badge',
                  bg: const Color(0xFFDDF1E4),
                  fg: AppColors.verified,
                  onTap: () => _go(context, TrustBadgeScreen()),
                ),
                _DrawerItem(
                  icon: 'verify_profile',
                  label: 'Verify your profile',
                  bg: const Color(0xFFDDF1E4),
                  fg: AppColors.verified,
                  onTap: () {
                    _go(context, VerifyProfileScreen());
                  },
                ),

                // ── ACTIVITY ───────────────────────────────────────────────
                const _GroupLabel('ACTIVITY'),
                _DrawerItem(
                  icon: 'chats',
                  label: 'Chat',
                  bg: const Color(0xFFDCE7F7),
                  fg: AppColors.navy,
                  onTap: () {
                    _go(context, const ChatsScreen());
                  },
                ),
                _DrawerItem(
                  icon: 'manage_interest',
                  label: 'Manage interest',
                  bg: const Color(0xFFFBE6D0),
                  fg: AppColors.brown,
                  onTap: () => _go(
                    context,
                    ManageInterestScreen()
                  ),
                ),
                _DrawerItem(
                  icon: 'manage_request',
                  label: 'Manage request',
                  bg: const Color(0xFFE6E1F6),
                  fg: AppColors.purple,
                  onTap: () => _go(
                    context,
                    ManageRequestScreen()
                  ),
                ),

                // ── ACCOUNT ────────────────────────────────────────────────
                const _GroupLabel('ACCOUNT'),
                _DrawerItem(
                  icon: 'subscription',
                  label: 'View subscriptions',
                  bg: const Color(0xFFFBE6D0),
                  fg: AppColors.brown,
                  onTap: () {
                    _go(context, SubscriptionScreen());
                  },
                ),
                _DrawerItem(
                  icon: 'privacy_settings',
                  label: 'Privacy Settings',
                  bg: const Color(0xFFDCE7F7),
                  fg: AppColors.navy,
                  onTap: () {
                    _go(context, PrivacySettingsScreen());
                  },
                ),
                _DrawerItem(
                  icon: 'safe_matrimony',
                  label: 'Safe matrimony',
                  bg: const Color(0xFFDCE7F7),
                  fg: AppColors.navy,
                  onTap: () => _go(context, SafeMatrimonyScreen()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20.w,
        MediaQuery.of(context).padding.top + 16.h,
        20.w,
        20.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(36.r)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealLight, AppColors.tealMid, AppColors.tealDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                padding: EdgeInsets.all(3.w),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldBorder,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar_male.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                    child: const Center(
                      child: AppIcon('close', size: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Priyesh',
            style: GoogleFonts.dmSans(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'VBM26836413F',
            style: GoogleFonts.dmSans(
              fontSize: 15.sp,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Profile completed',
                  style: GoogleFonts.dmSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '63%',
                style: GoogleFonts.dmSans(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.goldBorder,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: 0.63,
              minHeight: 7.h,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 20.h, 0, 8.h),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    this.onTap,
  });
  final String icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(child: AppIcon(icon, size: 22, color: fg)),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navyDark,
                ),
              ),
            ),
            const AppIcon(
              'chevron_right',
              size: 20,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
